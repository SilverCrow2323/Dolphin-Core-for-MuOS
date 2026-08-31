#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MAIN MENU - Main screen of the Frontendone
"""

import os
import sys

from core.logger import get_logger
from ui.base_screen import Screen
from ui.game_library import GameLibrary
from ui.workshop import Workshop
from ui.settings_docs import SettingsDocs

class MainMenu(Screen):
    """Main menu screen"""
    
    def __init__(self, app, gui):
        super().__init__(app, gui)
        self.logger = get_logger("main_menu")
        self.system_view = 0
        self.selected_index = 0
        
        self.menu_items = [
            {"name": "GameCube", "icon": "🎮"},
            {"name": "Nintendo Wii", "icon": "📺"},
            {"name": "Workshop", "icon": "🧩"},
            {"name": "Settings & Docs", "icon": "📂"},
            {"name": "Rescan ROMs", "icon": "🔄"},
            {"name": "Exit", "icon": "❌"},
        ]
        
        self.font_title = None
        self.font_menu = None
        self._load_fonts()
        
        self.logger.info("MainMenu initialized")
    
    def _load_fonts(self):
        font_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "assets", "fonts"
        )
        title_path = os.path.join(font_dir, "Oxanium-ExtraBold.ttf")
        menu_path = os.path.join(font_dir, "Oxanium-Regular.ttf")
        
        self.font_title = self.gui.load_font(title_path, 48)
        self.font_menu = self.gui.load_font(menu_path, 24)
        
        if not self.font_title:
            self.font_title = self.gui.load_font(None, 48)
        if not self.font_menu:
            self.font_menu = self.gui.load_font(None, 24)
    
    def enter(self):
        self.logger.info("MainMenu entered")
    
    def exit(self):
        self.logger.info("MainMenu exited")
    
    def on_key_down(self, key):
        from core.sdl2_gui import SDLK_UP, SDLK_DOWN, SDLK_RETURN, SDLK_ESCAPE, SDLK_TAB, SDLK_b
        
        if key == SDLK_ESCAPE or key == SDLK_b:
            self.app.running = False
        elif key == SDLK_UP:
            self.selected_index = max(0, self.selected_index - 1)
        elif key == SDLK_DOWN:
            self.selected_index = min(len(self.menu_items) - 1, self.selected_index + 1)
        elif key == SDLK_RETURN:
            self._execute_action()
        elif key == SDLK_TAB:
            self.system_view = 1 - self.system_view
            view_name = "Wii" if self.system_view == 1 else "GameCube"
            self.logger.info(f"Switched to {view_name} view")
    
    def _execute_action(self):
        item = self.menu_items[self.selected_index]
        self.logger.info(f"Selected: {item['name']}")
        name = item['name']
        
        if name == "Exit":
            self.app.running = False
        elif name == "GameCube":
            self.app.push_screen(GameLibrary(self.app, self.gui, system_view=0))
        elif name == "Nintendo Wii":
            self.app.push_screen(GameLibrary(self.app, self.gui, system_view=1))
        elif name == "Workshop":
            self.app.push_screen(Workshop(self.app, self.gui, self.system_view))
        elif name == "Settings & Docs":
            self.app.push_screen(SettingsDocs(self.app, self.gui, self.system_view))
        elif name == "Rescan ROMs":
            self.logger.info("Rescan ROMs not yet implemented")
    
    def render(self):
        W, H = self.gui.get_size()
        
        self.gui.clear(10, 14, 23)
        for i in range(H):
            r = 10 + int(i / H * 170)
            g = 14 + int(i / H * 166)
            b = 23 + int(i / H * 232)
            self.gui.draw_line(0, i, W, i, r, g, b)
        
        if self.font_title:
            surf = self.gui.render_text(self.font_title, "DOLPHIN muOS", 0, 200, 255)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, 20)
        
        y_start = 120
        for i, item in enumerate(self.menu_items):
            is_selected = i == self.selected_index
            color = (255, 255, 255) if is_selected else (150, 170, 200)
            
            self.gui.draw_rect(30, y_start + i * 60, 200, 40, 0, 180, 255, 40 if is_selected else 0)
            
            if self.font_menu:
                text = f"{item['icon']} {item['name']}"
                surf = self.gui.render_text(self.font_menu, text, color[0], color[1], color[2])
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, 50, y_start + i * 60 + 8)
        
        footer = "▲▼ Navigate  A Select  SELECT Rotate  ESC Exit"
        if self.font_menu:
            surf = self.gui.render_text(self.font_menu, footer, 100, 100, 120)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, H - 40)
        
        view_text = "GAMECUBE" if self.system_view == 0 else "NINTENDO WII"
        if self.font_menu:
            color = (0, 200, 255) if self.system_view == 0 else (255, 255, 255)
            surf = self.gui.render_text(self.font_menu, view_text, color[0], color[1], color[2])
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, W - tex.width - 30, 30)
    
    def update(self, delta):
        pass