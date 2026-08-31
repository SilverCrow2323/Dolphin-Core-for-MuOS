#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
COVER MANAGER - Gestione copertine da GameTDB con supporto regionale
"""

import os
import urllib.request
import hashlib
from core.logger import get_logger

class CoverManager:
    """Gestisce il download e la cache delle copertine da GameTDB"""
    
    # Mappatura carattere regione → codice GameTDB
    REGION_MAP = {
        'E': 'US',
        'P': 'EU',
        'J': 'JP',
        'K': 'KO',
        'D': 'AU',   # Australia
        'U': 'US',   # Alternativo per USA
        'T': 'EU',   # Alternativo per Europa
        'R': 'RU',   # Russia? Non comune
        'C': 'CN',   # Cina?
        'S': 'US',   # Sud America? A volte usano S per USA? In realtà per alcuni giochi S = USA? Meglio US.
    }
    
    def __init__(self, gui=None):
        self.logger = get_logger("cover_manager")
        self.gui = gui
        self.cache_dir = self._get_cache_dir()
        self._ensure_cache_dir()
    
    def _get_cache_dir(self):
        """Determina la directory di cache delle copertine"""
        frontend_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        cache_dir = os.path.join(frontend_root, "data", "cache", "covers")
        return cache_dir
    
    def _ensure_cache_dir(self):
        """Crea la directory di cache se non esiste"""
        os.makedirs(self.cache_dir, exist_ok=True)
    
    def _get_region_code(self, game_id):
        """Estrae il codice regione da Game ID per GameTDB"""
        if not game_id or len(game_id) < 4:
            return 'US'
        region_char = game_id[3]  # 4° carattere (0-index = 3)
        return self.REGION_MAP.get(region_char, 'US')
    
    def _get_system_prefix(self, game_id):
        """Determina il prefisso del sistema (wii o gc)"""
        if not game_id:
            return 'gc'
        first = game_id[0]
        if first == 'R':
            return 'wii'
        else:
            return 'gc'
    
    def get_cover_path(self, game_id):
        """Restituisce il percorso locale della copertina, se esiste"""
        if not game_id:
            return None
        
        # Prova estensioni comuni
        for ext in ['.png', '.jpg', '.jpeg']:
            path = os.path.join(self.cache_dir, f"{game_id}{ext}")
            if os.path.isfile(path):
                return path
        
        return None
    
    def download_cover(self, game_id, force=False):
        """Scarica la copertina da GameTDB usando la regione corretta"""
        if not game_id:
            return None
        
        # Verifica se già in cache
        local_path = self.get_cover_path(game_id)
        if local_path and not force:
            self.logger.info(f"Cover already cached: {local_path}")
            return local_path
        
        # Determina sistema e regione
        system = self._get_system_prefix(game_id)
        region = self._get_region_code(game_id)
        
        # Lista di regioni da provare (prima quella estratta, poi US)
        regions_to_try = [region]
        if region != 'US':
            regions_to_try.append('US')
        
        self.logger.info(f"Downloading cover for {game_id}, system={system}, region={region}")
        
        for reg in regions_to_try:
            # Costruisci URL
            if system == 'wii':
                url = f"https://art.gametdb.com/wii/cover/{reg}/{game_id}.png"
            else:
                url = f"https://art.gametdb.com/gc/cover/{reg}/{game_id}.png"
            
            self.logger.debug(f"Trying {url}")
            
            try:
                req = urllib.request.Request(
                    url,
                    headers={'User-Agent': 'DolphinRtCore/11.0'}
                )
                with urllib.request.urlopen(req, timeout=10) as response:
                    data = response.read()
                    # Salva
                    cache_path = os.path.join(self.cache_dir, f"{game_id}.png")
                    with open(cache_path, 'wb') as f:
                        f.write(data)
                    self.logger.info(f"Cover saved: {cache_path}")
                    # Carica texture se GUI disponibile
                    if self.gui:
                        texture = self.gui.load_texture(cache_path)
                        if texture:
                            return cache_path, texture
                    return cache_path
            except urllib.error.HTTPError as e:
                if e.code == 404:
                    self.logger.debug(f"Cover not found at {url}")
                    # Prova con .jpg per la stessa regione
                    try:
                        url_jpg = url.replace('.png', '.jpg')
                        req = urllib.request.Request(
                            url_jpg,
                            headers={'User-Agent': 'DolphinRtCore/11.0'}
                        )
                        with urllib.request.urlopen(req, timeout=10) as response:
                            data = response.read()
                            cache_path = os.path.join(self.cache_dir, f"{game_id}.jpg")
                            with open(cache_path, 'wb') as f:
                                f.write(data)
                            self.logger.info(f"Cover saved as JPG: {cache_path}")
                            if self.gui:
                                texture = self.gui.load_texture(cache_path)
                                if texture:
                                    return cache_path, texture
                            return cache_path
                    except:
                        pass
                    continue  # Prossima regione
                else:
                    self.logger.warning(f"HTTP error {e.code} for {url}")
                    continue
            except Exception as e:
                self.logger.warning(f"Failed to download cover from {url}: {e}")
                continue
        
        self.logger.warning(f"Cover not found for {game_id} in any region")
        return None
    
    def load_cover_texture(self, gui, game_id):
        """Carica la copertina come texture SDL"""
        if not game_id or not gui:
            return None
        
        # Prima cerca in cache
        local_path = self.get_cover_path(game_id)
        if local_path:
            texture = gui.load_texture(local_path)
            if texture:
                return texture
        
        # Se non c'è, scarica
        result = self.download_cover(game_id)
        if result:
            if isinstance(result, tuple):
                return result[1]  # (path, texture)
            else:
                texture = gui.load_texture(result)
                return texture
        
        return None