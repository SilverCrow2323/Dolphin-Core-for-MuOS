#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GAME DETAIL - Schermata di dettaglio del gioco
"""

import os
from core.logger import get_logger
from core.cover_manager import CoverManager
from core.game_db import GameDB
from ui.base_screen import Screen

class GameDetail(Screen):
    """Schermata di dettaglio con informazioni e opzioni per un gioco"""
    
    def __init__(self, app, gui, game):
        super().__init__(app, gui)
        self.logger = get_logger("game_detail")
        self.game = game
        self.selected_option = 0
        self.options = [
            "Launch Game",
            "Change Profile",
            "Game Settings",
            "Dump Textures",
            "Back"
        ]
        
        self.font_title = None
        self.font_normal = None
        self.font_small = None
        
        self.cover_manager = CoverManager(gui)
        self.game_db = GameDB()
        self.cover_texture = None
        
        self._load_fonts()
        self._load_cover()
    
    def _load_fonts(self):
        font_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "assets", "fonts"
        )
        self.font_title = self.gui.load_font(os.path.join(font_dir, "Oxanium-Bold.ttf"), 32)
        self.font_normal = self.gui.load_font(os.path.join(font_dir, "Oxanium-Regular.ttf"), 20)
        self.font_small = self.gui.load_font(os.path.join(font_dir, "Oxanium-Light.ttf"), 16)
        
        if not self.font_title:
            self.font_title = self.gui.load_font(None, 32)
        if not self.font_normal:
            self.font_normal = self.gui.load_font(None, 20)
        if not self.font_small:
            self.font_small = self.gui.load_font(None, 16)
    
    def _load_cover(self):
        """Carica la copertina del gioco"""
        game_id = self.game.get("id")
        if game_id:
            self.cover_texture = self.cover_manager.load_cover_texture(self.gui, game_id)
    
    def enter(self):
        self.logger.info(f"Entering detail for: {self.game.get('title', self.game.get('name', 'Unknown'))}")
    
    def on_key_down(self, key):
        from core.sdl2_gui import SDLK_UP, SDLK_DOWN, SDLK_RETURN, SDLK_ESCAPE, SDLK_b
        if key == SDLK_ESCAPE or key == SDLK_b:
            self.app.go_back()
        elif key == SDLK_UP:
            self.selected_option = max(0, self.selected_option - 1)
        elif key == SDLK_DOWN:
            self.selected_option = min(len(self.options) - 1, self.selected_option + 1)
        elif key == SDLK_RETURN:
            self._execute_option()
    
    def _execute_option(self):
        opt = self.options[self.selected_option]
        self.logger.info(f"Selected option: {opt}")
        if opt == "Launch Game":
            self.logger.info(f"Launching {self.game.get('title', self.game.get('name', 'Unknown'))}...")
        elif opt == "Change Profile":
            self.logger.info("Change Profile (not implemented)")
        elif opt == "Game Settings":
            self.logger.info("Game Settings (not implemented)")
        elif opt == "Dump Textures":
            self.logger.info("Dump Textures (not implemented)")
        elif opt == "Back":
            self.app.go_back()
    
    def render(self):
        W, H = self.gui.get_size()
        self.gui.clear(15, 10, 25)
        
        # Sfondo gradiente
        for i in range(H):
            r = 15 + int(i / H * 170)
            g = 10 + int(i / H * 166)
            b = 25 + int(i / H * 230)
            self.gui.draw_line(0, i, W, i, r, g, b)
        
        # Layout a due colonne
        left_x = 30
        right_x = 250
        cover_w = 200
        cover_h = int(cover_w * 1.05)
        
        # Copertina
        if self.cover_texture:
            # Adatta alla dimensione
            tw, th = self.cover_texture.width, self.cover_texture.height
            if tw > cover_w or th > cover_h:
                ratio = min(cover_w / tw, cover_h / th)
                dw, dh = int(tw * ratio), int(th * ratio)
                dx = left_x + (cover_w - dw) // 2
                dy = 60 + (cover_h - dh) // 2
                self.gui.draw_texture_scaled(self.cover_texture, dx, dy, dw, dh)
            else:
                dx = left_x + (cover_w - tw) // 2
                dy = 60 + (cover_h - th) // 2
                self.gui.draw_texture(self.cover_texture, dx, dy)
        else:
            # Placeholder
            self.gui.draw_rect(left_x, 60, cover_w, cover_h, 60, 70, 90, 200, fill=True)
            if self.font_normal:
                title = self.game.get("title", self.game.get("name", "??"))
                initials = "".join([w[0].upper() for w in title.split()[:3] if w])[:3]
                surf = self.gui.render_text(self.font_normal, initials, 200, 200, 200)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, left_x + (cover_w - tex.width)//2, 60 + (cover_h - tex.height)//2)
        
        # Titolo (a destra della cover)
        title = self.game.get("title", self.game.get("name", "Unknown"))
        if self.font_title:
            surf = self.gui.render_text(self.font_title, title, 0, 200, 255)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, right_x, 60)
        
        # Info
        y_info = 110
        if self.font_normal:
            game_id = self.game.get("id", "Unknown")
            system = self.game.get("system", "Unknown")
            region = self.game.get("region", "Unknown")
            size = self.game.get("size", "0 MB")
            
            info_lines = [
                f"ID: {game_id}",
                f"System: {system}",
                f"Region: {region}",
                f"Size: {size}",
            ]
            
            # Rating
            rating = self.game.get("rating")
            if rating is not None:
                compatibility = self.game_db.get_compatibility_label(self.game.get("id"))
                stars = "★" * rating + "☆" * (5 - rating)
                info_lines.append(f"Rating: {stars} ({compatibility})")
            
            # FPS
            fps = self.game.get("fps")
            if fps:
                info_lines.append(f"FPS: {fps}")
            
            # Considerations
            considerations = self.game.get("considerations")
            if considerations:
                info_lines.append(f"Note: {considerations[:60]}...")
            
            for line in info_lines:
                surf = self.gui.render_text(self.font_normal, line, 200, 200, 220)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, right_x, y_info)
                        y_info += 28
        
        # Opzioni (sotto la cover)
        opt_y = 60 + cover_h + 30
        for idx, opt in enumerate(self.options):
            is_sel = idx == self.selected_option
            color = (255, 255, 255) if is_sel else (180, 180, 200)
            bg_alpha = 60 if is_sel else 0
            self.gui.draw_rect(left_x, opt_y + idx * 40, 200, 34, 0, 180, 255, bg_alpha)
            if self.font_normal:
                surf = self.gui.render_text(self.font_normal, opt, color[0], color[1], color[2])
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, left_x + 10, opt_y + idx * 40 + 4)
        
        # Footer
        footer = "▲▼ Navigate  A Select  B Back"
        if self.font_normal:
            surf = self.gui.render_text(self.font_normal, footer, 150, 150, 170)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, H - 40)