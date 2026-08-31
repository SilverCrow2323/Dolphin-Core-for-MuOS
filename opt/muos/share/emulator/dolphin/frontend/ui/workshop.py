#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
WORKSHOP - Control center for profiles, dumps, controllers, and reports
"""

import os
from core.logger import get_logger
from ui.base_screen import Screen

class Workshop(Screen):
    """Workshop screen with 6 sections"""
    
    SECTIONS = [
        {"name": "Game Settings", "icon": "📋", "desc": "Per-game .cfg files in GameSettings"},
        {"name": "Rt:Core Profiles", "icon": "⚙️", "desc": "Core profiles in info/assign/"},
        {"name": "Dump Manager", "icon": "🖼️", "desc": "Texture dumps grouped by game"},
        {"name": "Controller Settings", "icon": "🎮", "desc": "Controller profiles in Config/"},
        {"name": "Game Reports", "icon": "📊", "desc": "Session reports per game"},
        {"name": "Graphics Mods", "icon": "🎨", "desc": "Graphical mods per game"},
    ]
    
    def __init__(self, app, gui, system_view=0):
        super().__init__(app, gui)
        self.logger = get_logger("workshop")
        self.system_view = system_view  # 0=GC, 1=Wii
        self.selected_section = 0
        self.selected_item = 0
        
        self.font_title = None
        self.font_normal = None
        self.font_small = None
        self._load_fonts()
        
        self.logger.info("Workshop initialized")
    
    def _load_fonts(self):
        """Load fonts"""
        font_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "assets", "fonts"
        )
        self.font_title = self.gui.load_font(os.path.join(font_dir, "Oxanium-Bold.ttf"), 28)
        self.font_normal = self.gui.load_font(os.path.join(font_dir, "Oxanium-Regular.ttf"), 18)
        self.font_small = self.gui.load_font(os.path.join(font_dir, "Oxanium-Light.ttf"), 14)
        
        if not self.font_title:
            self.font_title = self.gui.load_font(None, 28)
        if not self.font_normal:
            self.font_normal = self.gui.load_font(None, 18)
        if not self.font_small:
            self.font_small = self.gui.load_font(None, 14)
    
    def enter(self):
        self.logger.info("Entering Workshop")
    
    def on_key_down(self, key):
        from core.sdl2_gui import SDLK_UP, SDLK_DOWN, SDLK_RETURN, SDLK_ESCAPE, SDLK_TAB, SDLK_b
        
        if key == SDLK_ESCAPE or key == SDLK_b:
            self.app.go_back()
        elif key == SDLK_TAB:  # SELECT
            self.system_view = 1 - self.system_view
            view = "Wii" if self.system_view == 1 else "GameCube"
            self.logger.info(f"Switched to {view} view")
        elif key == SDLK_UP:
            self.selected_section = max(0, self.selected_section - 1)
        elif key == SDLK_DOWN:
            self.selected_section = min(len(self.SECTIONS) - 1, self.selected_section + 1)
        elif key == SDLK_RETURN:
            self._open_section()
    
    def _open_section(self):
        """Open the selected section"""
        section = self.SECTIONS[self.selected_section]
        self.logger.info(f"Opening section: {section['name']}")
        # TODO: Implement each section
    
    def render(self):
        W, H = self.gui.get_size()
        
        # Background
        self.gui.clear(15, 12, 28)
        for i in range(H):
            r = 15 + int(i / H * 180)
            g = 12 + int(i / H * 170)
            b = 28 + int(i / H * 230)
            self.gui.draw_line(0, i, W, i, r, g, b)
        
        # Title
        if self.font_title:
            surf = self.gui.render_text(self.font_title, "🧩 WORKSHOP", 0, 200, 255)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, 20)
        
        # View indicator
        view_text = "GAMECUBE" if self.system_view == 0 else "NINTENDO WII"
        if self.font_small:
            surf = self.gui.render_text(self.font_small, view_text, 0, 200, 255, 180, 180, 200)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, W - tex.width - 30, 30)
        
        # Sections
        y = 80
        card_h = 70
        card_w = W - 60
        spacing = 8
        
        for i, section in enumerate(self.SECTIONS):
            is_selected = i == self.selected_section
            x = 30
            y_pos = y + i * (card_h + spacing)
            
            # Card background
            bg_color = (40, 60, 90) if is_selected else (25, 35, 55)
            self.gui.draw_rect(x, y_pos, card_w, card_h, bg_color[0], bg_color[1], bg_color[2], 200, fill=True)
            
            if is_selected:
                self.gui.draw_rect(x, y_pos, card_w, card_h, 0, 200, 255, 150, fill=False)
            
            # Icon
            if self.font_normal:
                surf = self.gui.render_text(self.font_normal, section["icon"], 200, 200, 220)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, x + 15, y_pos + 15)
            
            # Name
            if self.font_normal:
                color = (255, 255, 255) if is_selected else (200, 200, 220)
                surf = self.gui.render_text(self.font_normal, section["name"], color[0], color[1], color[2])
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, x + 50, y_pos + 10)
            
            # Description
            if self.font_small:
                surf = self.gui.render_text(self.font_small, section["desc"], 150, 160, 180)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, x + 50, y_pos + 36)
        
        # Footer
        footer = "▲▼ Navigate  A Select  SELECT Rotate  B Back  ESC Exit"
        if self.font_small:
            surf = self.gui.render_text(self.font_small, footer, 130, 130, 150)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, H - 40)
    
    def update(self, delta):
        pass