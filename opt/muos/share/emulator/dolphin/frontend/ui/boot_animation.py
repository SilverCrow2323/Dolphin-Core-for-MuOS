#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
BOOT ANIMATION - Startup splash screen with Dolphin logo
"""

import os
import time
from core.logger import get_logger
from ui.base_screen import Screen

class BootAnimation(Screen):
    """Boot animation screen with logo and loading bar"""
    
    def __init__(self, app, gui):
        super().__init__(app, gui)
        self.logger = get_logger("boot_animation")
        self.font_title = None
        self.font_sub = None
        self.font_footer = None
        self.font_loading = None
        self.logo_texture = None
        self.start_time = 0
        self.duration = 2.0  # 2 seconds
        self.progress = 0.0
        self.loading = True
        
        self._load_assets()
        self.logger.info("BootAnimation initialized")
    
    def _load_assets(self):
        """Load fonts and logo texture"""
        font_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "assets", "fonts"
        )
        images_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "assets", "images"
        )
        
        # Load fonts
        self.font_title = self.gui.load_font(
            os.path.join(font_dir, "Oxanium-ExtraBold.ttf"), 72
        )
        self.font_sub = self.gui.load_font(
            os.path.join(font_dir, "Oxanium-Light.ttf"), 24
        )
        self.font_footer = self.gui.load_font(
            os.path.join(font_dir, "Oxanium-Regular.ttf"), 16
        )
        self.font_loading = self.gui.load_font(
            os.path.join(font_dir, "Oxanium-Bold.ttf"), 20
        )
        
        # Fallback
        if not self.font_title:
            self.font_title = self.gui.load_font(None, 72)
        if not self.font_sub:
            self.font_sub = self.gui.load_font(None, 24)
        if not self.font_footer:
            self.font_footer = self.gui.load_font(None, 16)
        if not self.font_loading:
            self.font_loading = self.gui.load_font(None, 20)
        
        # Load logo
        logo_path = os.path.join(images_dir, "dolphin_logo.png")
        if os.path.exists(logo_path):
            self.logo_texture = self.gui.load_texture(logo_path)
    
    def enter(self):
        """Called when boot animation starts"""
        self.logger.info("Boot animation started")
        self.start_time = time.time()
        self.progress = 0.0
        self.loading = True
    
    def update(self, delta):
        """Update progress over time"""
        if self.loading:
            elapsed = time.time() - self.start_time
            self.progress = min(1.0, elapsed / self.duration)
            
            if self.progress >= 1.0:
                self.loading = False
                # Auto-advance to main menu
                self.app.pop_screen()
    
    def render(self):
        """Render the boot animation"""
        W, H = self.gui.get_size()
        
        # Background with gradient (dark blue to purple)
        for i in range(H):
            r = 10 + int(i / H * 40)
            g = 10 + int(i / H * 20)
            b = 30 + int(i / H * 50)
            self.gui.draw_line(0, i, W, i, r, g, b)
        
        # Center coordinates
        cx = W // 2
        cy = H // 2 - 40
        
        # Logo
        if self.logo_texture:
            # Scale logo to fit
            max_w = W * 0.6
            max_h = H * 0.35
            tw, th = self.logo_texture.width, self.logo_texture.height
            
            if tw > max_w or th > max_h:
                scale = min(max_w / tw, max_h / th)
                dw, dh = int(tw * scale), int(th * scale)
                dx, dy = cx - dw//2, cy - dh//2
                self.gui.draw_texture_scaled(self.logo_texture, dx, dy, dw, dh)
            else:
                self.gui.draw_texture(self.logo_texture, cx - tw//2, cy - th//2)
        else:
            # Text logo fallback
            if self.font_title:
                surf = self.gui.render_text(self.font_title, "DOLPHIN", 0, 200, 255)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, cx - tex.width//2, cy - tex.height//2)
        
        # Subtitle
        y_sub = cy + 80
        if self.font_sub:
            surf = self.gui.render_text(self.font_sub, "muOS · Frontendone", 180, 180, 200)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, cx - tex.width//2, y_sub)
        
        # Loading bar
        y_bar = y_sub + 50
        bar_w = 400
        bar_h = 12
        bar_x = cx - bar_w//2
        
        # Background
        self.gui.draw_rect(bar_x, y_bar, bar_w, bar_h, 40, 50, 70, 200, fill=True)
        self.gui.draw_rect(bar_x, y_bar, bar_w, bar_h, 80, 120, 180, 150, fill=False)
        
        # Progress
        fill_w = int(bar_w * self.progress)
        if fill_w > 0:
            self.gui.draw_rect(bar_x, y_bar, fill_w, bar_h, 0, 200, 255, 200, fill=True)
        
        # Progress text
        if self.font_loading:
            pct = int(self.progress * 100)
            surf = self.gui.render_text(self.font_loading, f"{pct}%", 200, 200, 220)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, cx - tex.width//2, y_bar + bar_h + 10)
        
        # Footer
        y_footer = H - 40
        if self.font_footer:
            surf = self.gui.render_text(self.font_footer, "SPDW Factory", 100, 100, 120)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, cx - tex.width//2, y_footer)