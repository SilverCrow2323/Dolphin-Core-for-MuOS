#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SETTINGS & DOCS - Settings and documentation screen
"""

import os
from core.logger import get_logger
from ui.base_screen import Screen

class SettingsDocs(Screen):
    """Settings & Documentation screen with tabs"""
    
    def __init__(self, app, gui, system_view=0):
        super().__init__(app, gui)
        self.logger = get_logger("settings_docs")
        self.system_view = system_view
        self.current_tab = 0  # 0=Settings, 1=Documentation
        self.selected_setting = 0
        self.selected_doc = 0
        
        self.font_title = None
        self.font_normal = None
        self.font_small = None
        self._load_fonts()
        
        # Settings sections
        self.settings_sections = [
            "BGM Settings",
            "ROM Paths",
            "Resource Packs",
            "System Info",
            "Upgrades",
        ]
        
        # Documentation sections
        self.doc_sections = [
            "README",
            "Changelog",
            "Compatibility GC",
            "Compatibility Wii",
            "Credits",
        ]
        
        self.logger.info("SettingsDocs initialized")
    
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
        self.logger.info("Entering Settings & Docs")
    
    def on_key_down(self, key):
        from core.sdl2_gui import SDLK_UP, SDLK_DOWN, SDLK_LEFT, SDLK_RIGHT, SDLK_RETURN, SDLK_ESCAPE, SDLK_TAB, SDLK_b, SDLK_l, SDLK_r
        
        if key == SDLK_ESCAPE or key == SDLK_b:
            self.app.go_back()
        elif key == SDLK_TAB:  # SELECT
            self.system_view = 1 - self.system_view
            view = "Wii" if self.system_view == 1 else "GameCube"
            self.logger.info(f"Switched to {view} view")
        elif key == SDLK_LEFT:
            self.current_tab = 0
        elif key == SDLK_RIGHT:
            self.current_tab = 1
        elif key == SDLK_UP:
            if self.current_tab == 0:
                self.selected_setting = max(0, self.selected_setting - 1)
            else:
                self.selected_doc = max(0, self.selected_doc - 1)
        elif key == SDLK_DOWN:
            if self.current_tab == 0:
                self.selected_setting = min(len(self.settings_sections) - 1, self.selected_setting + 1)
            else:
                self.selected_doc = min(len(self.doc_sections) - 1, self.selected_doc + 1)
        elif key == SDLK_RETURN:
            self._open_selected()
    
    def _open_selected(self):
        """Open the selected item"""
        if self.current_tab == 0:
            section = self.settings_sections[self.selected_setting]
            self.logger.info(f"Opening setting: {section}")
        else:
            section = self.doc_sections[self.selected_doc]
            self.logger.info(f"Opening doc: {section}")
    
    def render(self):
        W, H = self.gui.get_size()
        
        # Background
        self.gui.clear(12, 15, 25)
        for i in range(H):
            r = 12 + int(i / H * 175)
            g = 15 + int(i / H * 170)
            b = 25 + int(i / H * 235)
            self.gui.draw_line(0, i, W, i, r, g, b)
        
        # Title
        if self.font_title:
            surf = self.gui.render_text(self.font_title, "📂 SETTINGS & DOCS", 0, 200, 255)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, 20)
        
        # View indicator
        view_text = "GAMECUBE" if self.system_view == 0 else "NINTENDO WII"
        if self.font_small:
            surf = self.gui.render_text(self.font_small, view_text, 180, 180, 200)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, W - tex.width - 30, 30)
        
        # Tab headers
        tabs = ["⚙️ Settings", "📄 Documentation"]
        tab_w = 200
        tab_h = 40
        tab_y = 70
        
        for i, tab in enumerate(tabs):
            x = 30 + i * (tab_w + 10)
            is_active = i == self.current_tab
            bg_color = (0, 180, 255, 60) if is_active else (30, 40, 60, 150)
            self.gui.draw_rect(x, tab_y, tab_w, tab_h, bg_color[0], bg_color[1], bg_color[2], bg_color[3] if len(bg_color) > 3 else 200, fill=True)
            
            if is_active:
                self.gui.draw_rect(x, tab_y, tab_w, tab_h, 0, 200, 255, 150, fill=False)
            
            if self.font_normal:
                surf = self.gui.render_text(self.font_normal, tab, 255, 255, 255 if is_active else 180, 180, 200)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, x + (tab_w - tex.width)//2, tab_y + (tab_h - tex.height)//2)
        
        # Content
        content_y = tab_y + tab_h + 10
        content_h = H - content_y - 50
        
        if self.current_tab == 0:
            self._render_settings(content_y, content_h, W)
        else:
            self._render_docs(content_y, content_h, W)
        
        # Footer
        footer = "◄ L1  R1 ► Tabs  ▲▼ Navigate  A Select  SELECT Rotate  B Back"
        if self.font_small:
            surf = self.gui.render_text(self.font_small, footer, 130, 130, 150)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, H - 40)
    
    def _render_settings(self, y, max_h, W):
        """Render settings list"""
        items = self.settings_sections
        line_h = 32
        visible = min(len(items), max_h // line_h)
        
        for i in range(visible):
            idx = self.selected_setting - visible//2 + i
            if 0 <= idx < len(items):
                is_selected = idx == self.selected_setting
                x = 40
                y_pos = y + i * line_h
                
                bg_color = (40, 60, 90) if is_selected else (20, 30, 50)
                self.gui.draw_rect(x, y_pos, W - 80, line_h - 2, bg_color[0], bg_color[1], bg_color[2], 150, fill=True)
                
                if self.font_normal:
                    color = (255, 255, 255) if is_selected else (200, 200, 220)
                    surf = self.gui.render_text(self.font_normal, items[idx], color[0], color[1], color[2])
                    if surf:
                        tex = self.gui.create_texture_from_surface(surf)
                        if tex:
                            self.gui.draw_texture(tex, x + 10, y_pos + 4)
    
    def _render_docs(self, y, max_h, W):
        """Render documentation list"""
        items = self.doc_sections
        line_h = 32
        visible = min(len(items), max_h // line_h)
        
        for i in range(visible):
            idx = self.selected_doc - visible//2 + i
            if 0 <= idx < len(items):
                is_selected = idx == self.selected_doc
                x = 40
                y_pos = y + i * line_h
                
                bg_color = (40, 60, 90) if is_selected else (20, 30, 50)
                self.gui.draw_rect(x, y_pos, W - 80, line_h - 2, bg_color[0], bg_color[1], bg_color[2], 150, fill=True)
                
                if self.font_normal:
                    color = (255, 255, 255) if is_selected else (200, 200, 220)
                    surf = self.gui.render_text(self.font_normal, items[idx], color[0], color[1], color[2])
                    if surf:
                        tex = self.gui.create_texture_from_surface(surf)
                        if tex:
                            self.gui.draw_texture(tex, x + 10, y_pos + 4)
    
    def update(self, delta):
        pass