#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GAME LIBRARY - Schermata di visualizzazione e selezione dei giochi
"""

import os
import time
import math
from core.logger import get_logger
from core.scanner import GameScanner
from core.game_db import GameDB
from core.cover_manager import CoverManager
from ui.base_screen import Screen
from ui.game_detail import GameDetail

class GameLibrary(Screen):
    """Schermata per visualizzare e filtrare i giochi"""
    
    VIEW_GRID = 0
    VIEW_LIST = 1
    VIEW_DETAILED_LIST = 2
    
    # Mappatura regioni per icone
    REGION_ICONS = {
        "NTSC": "US",
        "PAL": "EU",
        "NTSC-J": "JP",
        "Unknown": "??",
        "World": "🌍",
    }
    
    def __init__(self, app, gui, system_view=0):
        super().__init__(app, gui)
        self.logger = get_logger("game_library")
        self.system_view = system_view
        self.games = []
        self.filtered_games = []
        self.current_page = 0
        self.page_size = 25
        self.selected_index = 0
        self.view_mode = self.VIEW_GRID
        self.search_text = ""
        self.filter_system = "all"
        self.sort_by = "name"
        self.sort_asc = True
        
        # Core modules
        self.game_db = GameDB()
        self.scanner = GameScanner(game_db=self.game_db)
        self.cover_manager = CoverManager(gui)
        
        # Fonts
        self.font_title = None
        self.font_normal = None
        self.font_small = None
        self.font_region = None
        self._load_fonts()
        
        # Placeholder texture (creata al volo)
        self.placeholder_tex = None
        
        # Scansione
        self.scanning = False
        self.scan_progress = 0
        self._refresh_games()
    
    def _load_fonts(self):
        font_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "assets", "fonts"
        )
        self.font_title = self.gui.load_font(os.path.join(font_dir, "Oxanium-Bold.ttf"), 28)
        self.font_normal = self.gui.load_font(os.path.join(font_dir, "Oxanium-Regular.ttf"), 18)
        self.font_small = self.gui.load_font(os.path.join(font_dir, "Oxanium-Light.ttf"), 14)
        self.font_region = self.gui.load_font(os.path.join(font_dir, "Oxanium-ExtraBold.ttf"), 12)
        
        # Fallback
        if not self.font_title:
            self.font_title = self.gui.load_font(None, 28)
        if not self.font_normal:
            self.font_normal = self.gui.load_font(None, 18)
        if not self.font_small:
            self.font_small = self.gui.load_font(None, 14)
        if not self.font_region:
            self.font_region = self.gui.load_font(None, 12)
    
    def _refresh_games(self):
        """Scansiona e ricarica la lista dei giochi"""
        self.logger.info("Refreshing game list...")
        system_filter = "gc" if self.system_view == 0 else "wii"
        self.games = self.scanner.scan(system=system_filter)
        self._apply_filters()
        self.current_page = 0
        self.selected_index = 0
        self.logger.info(f"Loaded {len(self.games)} games")
    
    def _apply_filters(self):
        """Applica filtro e ordinamento alla lista"""
        filtered = self.games[:]
        
        # Filtro per sistema
        if self.filter_system != "all":
            filtered = [g for g in filtered if g["system"].lower() == self.filter_system.lower()]
        
        # Filtro per testo di ricerca
        if self.search_text:
            search_lower = self.search_text.lower()
            filtered = [
                g for g in filtered 
                if search_lower in g.get("title", g.get("name", "")).lower() or 
                   (g.get("id") and search_lower in g["id"].lower())
            ]
        
        # Ordinamento
        reverse = not self.sort_asc
        if self.sort_by == "name":
            filtered.sort(key=lambda g: g.get("title", g.get("name", "")).lower(), reverse=reverse)
        elif self.sort_by == "region":
            filtered.sort(key=lambda g: g.get("region", ""), reverse=reverse)
        elif self.sort_by == "rating":
            def rating_key(g):
                return g.get("rating", -1)
            filtered.sort(key=rating_key, reverse=reverse)
        elif self.sort_by == "size":
            filtered.sort(key=lambda g: g.get("size_bytes", 0), reverse=reverse)
        
        self.filtered_games = filtered
    
    def enter(self):
        self.logger.info("Entering Game Library")
        if not self.games:
            self._refresh_games()
    
    def on_key_down(self, key):
        from core.sdl2_gui import SDLK_UP, SDLK_DOWN, SDLK_LEFT, SDLK_RIGHT, SDLK_RETURN, SDLK_ESCAPE, SDLK_TAB, SDLK_x, SDLK_y, SDLK_b, SDLK_s, SDLK_f
        
        if key == SDLK_ESCAPE:
            self.app.go_back()
            return
        elif key == SDLK_TAB:
            self.system_view = 1 - self.system_view
            self._refresh_games()
            self.logger.info(f"Switched to {'Wii' if self.system_view else 'GC'} view")
            return
        elif key == SDLK_b:
            self.app.go_back()
            return
        
        total = len(self.filtered_games)
        if total == 0:
            return
        
        cols = 5 if self.view_mode == self.VIEW_GRID else 1
        
        if key == SDLK_UP:
            self.selected_index = max(0, self.selected_index - (cols if self.view_mode == self.VIEW_GRID else 1))
        elif key == SDLK_DOWN:
            self.selected_index = min(total - 1, self.selected_index + (cols if self.view_mode == self.VIEW_GRID else 1))
        elif key == SDLK_LEFT:
            if self.view_mode == self.VIEW_GRID:
                self.selected_index = max(0, self.selected_index - 1)
        elif key == SDLK_RIGHT:
            if self.view_mode == self.VIEW_GRID:
                self.selected_index = min(total - 1, self.selected_index + 1)
        elif key == SDLK_RETURN:
            if self.selected_index < len(self.filtered_games):
                game = self.filtered_games[self.selected_index]
                self.app.push_screen(GameDetail(self.app, self.gui, game))
        elif key == SDLK_x:
            filters = ["all", "gc", "wii"]
            idx = filters.index(self.filter_system) if self.filter_system in filters else 0
            self.filter_system = filters[(idx + 1) % len(filters)]
            self._apply_filters()
            self.selected_index = 0
        elif key == SDLK_y:
            self.view_mode = (self.view_mode + 1) % 3
        elif key == SDLK_s:
            self._start_search()
        elif key == SDLK_f:
            sort_options = ["name", "region", "rating", "size"]
            idx = sort_options.index(self.sort_by) if self.sort_by in sort_options else 0
            self.sort_by = sort_options[(idx + 1) % len(sort_options)]
            self._apply_filters()
    
    def _start_search(self):
        self.logger.info("Search not implemented yet")
    
    def _get_region_icon(self, region):
        """Restituisce l'icona/testo per la regione"""
        if not region or region == "Unknown":
            return "??"
        return self.REGION_ICONS.get(region, region[:2].upper())
    
    def _get_region_color(self, region):
        """Colore per la regione"""
        colors = {
            "NTSC": (0, 180, 255),
            "PAL": (255, 200, 0),
            "NTSC-J": (255, 100, 100),
            "Unknown": (150, 150, 150),
        }
        return colors.get(region, (150, 150, 150))
    
    def render(self):
        W, H = self.gui.get_size()
        
        # Sfondo
        self.gui.clear(10, 14, 23)
        for i in range(H):
            r = 10 + int(i / H * 170)
            g = 14 + int(i / H * 166)
            b = 23 + int(i / H * 232)
            self.gui.draw_line(0, i, W, i, r, g, b)
        
        # Intestazione
        header = "GAME CUBE" if self.system_view == 0 else "NINTENDO WII"
        if self.font_title:
            surf = self.gui.render_text(self.font_title, header, 0, 200, 255)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, 20)
        
        # Info
        y_header = 70
        if self.font_normal:
            info = f"{len(self.filtered_games)} games found"
            if self.filter_system != "all":
                info += f" | Filter: {self.filter_system.upper()}"
            if self.sort_by:
                info += f" | Sort: {self.sort_by.capitalize()}"
            surf = self.gui.render_text(self.font_normal, info, 180, 180, 200)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, y_header)
        
        # Nessun gioco
        if not self.filtered_games:
            if self.font_normal:
                surf = self.gui.render_text(self.font_normal, "No games found. Press X to rescan.", 200, 200, 200)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, W//2 - tex.width//2, H//2)
            return
        
        # Paginazione
        total = len(self.filtered_games)
        num_pages = math.ceil(total / self.page_size)
        start = self.current_page * self.page_size
        end = min(start + self.page_size, total)
        page_games = self.filtered_games[start:end]
        
        # Disegna la vista
        if self.view_mode == self.VIEW_GRID:
            self._render_grid(page_games, start, W, H)
        else:
            self._render_list(page_games, start, W, H)
        
        # Footer
        y_footer = H - 40
        if self.font_small:
            nav = "▲▼ Navigate  A Select  X Filter  Y View  S Search  F Sort  SELECT Rotate  ESC Back"
            surf = self.gui.render_text(self.font_small, nav, 150, 150, 170)
            if surf:
                tex = self.gui.create_texture_from_surface(surf)
                if tex:
                    self.gui.draw_texture(tex, 30, y_footer)
        
        # Pagina corrente
        if num_pages > 1:
            page_info = f"Page {self.current_page+1}/{num_pages}"
            if self.font_small:
                surf = self.gui.render_text(self.font_small, page_info, 200, 200, 200)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, W - tex.width - 30, y_footer)
    
    def _render_grid(self, games, offset, W, H):
        """Disegna la vista a griglia (5 colonne)"""
        cols = 5
        rows = 5
        card_w = (W - 80) // cols
        card_h = int(card_w * 1.5)
        spacing_x = 10
        spacing_y = 10
        start_x = 30
        start_y = 100
        
        for idx, game in enumerate(games):
            row = idx // cols
            col = idx % cols
            x = start_x + col * (card_w + spacing_x)
            y = start_y + row * (card_h + spacing_y)
            
            is_selected = (offset + idx) == self.selected_index
            
            # Sfondo card
            bg_color = (40, 60, 80) if is_selected else (20, 30, 50)
            self.gui.draw_rect(x, y, card_w, card_h, bg_color[0], bg_color[1], bg_color[2], 200, fill=True)
            if is_selected:
                self.gui.draw_rect(x, y, card_w, card_h, 0, 200, 255, 200, fill=False)
            
            # Copertina
            cover_w = card_w - 12
            cover_h = int(cover_w * 0.75)
            cx = x + 6
            cy = y + 6
            
            # Prova a caricare la copertina
            cover_tex = self.cover_manager.load_cover_texture(self.gui, game.get("id"))
            if cover_tex:
                # Ridimensiona mantenendo proporzioni
                tex_w, tex_h = cover_tex.width, cover_tex.height
                if tex_w > cover_w or tex_h > cover_h:
                    ratio = min(cover_w / tex_w, cover_h / tex_h)
                    draw_w = int(tex_w * ratio)
                    draw_h = int(tex_h * ratio)
                    dx = cx + (cover_w - draw_w) // 2
                    dy = cy + (cover_h - draw_h) // 2
                    self.gui.draw_texture_scaled(cover_tex, dx, dy, draw_w, draw_h)
                else:
                    dx = cx + (cover_w - tex_w) // 2
                    dy = cy + (cover_h - tex_h) // 2
                    self.gui.draw_texture(cover_tex, dx, dy)
            else:
                # Placeholder
                self.gui.draw_rect(cx, cy, cover_w, cover_h, 60, 70, 90, 200, fill=True)
                # Iniziali
                if self.font_small:
                    title = game.get("title", game.get("name", "??"))
                    initials = "".join([w[0].upper() for w in title.split()[:3] if w])[:3]
                    surf = self.gui.render_text(self.font_small, initials, 200, 200, 200)
                    if surf:
                        tex = self.gui.create_texture_from_surface(surf)
                        if tex:
                            self.gui.draw_texture(tex, cx + (cover_w - tex.width)//2, cy + (cover_h - tex.height)//2)
            
            # Nome gioco (sotto la cover)
            name_y = y + cover_h + 8
            if self.font_small:
                display_name = game.get("title", game.get("name", "Unknown"))
                if len(display_name) > 20:
                    display_name = display_name[:18] + "..."
                surf = self.gui.render_text(self.font_small, display_name, 220, 220, 240)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, x + (card_w - tex.width)//2, name_y)
            
            # Regione icon (angolo in basso a destra della cover)
            region = game.get("region", "Unknown")
            region_label = self._get_region_icon(region)
            region_color = self._get_region_color(region)
            
            # Sfondo regione
            rw, rh = 28, 16
            rx = x + card_w - rw - 6
            ry = y + cover_h - rh - 4
            self.gui.draw_rect(rx, ry, rw, rh, region_color[0], region_color[1], region_color[2], 200, fill=True)
            self.gui.draw_rect(rx, ry, rw, rh, 255, 255, 255, 80, fill=False)
            
            # Testo regione
            if self.font_region:
                surf = self.gui.render_text(self.font_region, region_label, 255, 255, 255)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, rx + (rw - tex.width)//2, ry + (rh - tex.height)//2)
            
            # Rating (stelle)
            rating = game.get("rating")
            if rating is not None and rating > 0:
                stars = "★" * rating + "☆" * (5 - rating)
                star_color = self.game_db.get_compatibility_color(game.get("id")) or (200, 200, 200)
                if self.font_small:
                    surf = self.gui.render_text(self.font_small, stars, star_color[0], star_color[1], star_color[2])
                    if surf:
                        tex = self.gui.create_texture_from_surface(surf)
                        if tex:
                            self.gui.draw_texture(tex, x + 6, y + cover_h + 24)
    
    def _render_list(self, games, offset, W, H):
        """Disegna la vista a lista"""
        start_y = 100
        line_height = 32
        max_lines = (H - start_y - 80) // line_height
        visible = games[:max_lines]
        
        for idx, game in enumerate(visible):
            y = start_y + idx * line_height
            is_selected = (offset + idx) == self.selected_index
            
            bg_color = (40, 60, 80) if is_selected else (20, 30, 50)
            self.gui.draw_rect(30, y, W - 60, line_height-2, bg_color[0], bg_color[1], bg_color[2], 150, fill=True)
            
            # Nome
            title = game.get("title", game.get("name", "Unknown"))
            if self.font_normal:
                display = title[:40] + ("..." if len(title) > 40 else "")
                surf = self.gui.render_text(self.font_normal, display, 220, 220, 240)
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, 40, y + 4)
            
            # Regione (a destra)
            region = game.get("region", "Unknown")
            region_label = self._get_region_icon(region)
            region_color = self._get_region_color(region)
            if self.font_small:
                surf = self.gui.render_text(self.font_small, region_label, region_color[0], region_color[1], region_color[2])
                if surf:
                    tex = self.gui.create_texture_from_surface(surf)
                    if tex:
                        self.gui.draw_texture(tex, W - tex.width - 80, y + 6)
            
            # Rating
            rating = game.get("rating")
            if rating is not None and rating > 0:
                stars = "★" * rating
                star_color = self.game_db.get_compatibility_color(game.get("id")) or (200, 200, 200)
                if self.font_small:
                    surf = self.gui.render_text(self.font_small, stars, star_color[0], star_color[1], star_color[2])
                    if surf:
                        tex = self.gui.create_texture_from_surface(surf)
                        if tex:
                            self.gui.draw_texture(tex, W - 60 - tex.width, y + 6)