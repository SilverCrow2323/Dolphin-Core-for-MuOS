#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SCANNER - Scansione delle ROM GameCube e Wii
"""

import os
import re
import json
from core.logger import get_logger

class GameScanner:
    """Scansiona le cartelle ROM per trovare giochi GC e Wii"""
    
    # Estensioni supportate
    EXTENSIONS_GC = {'.iso', '.gcm', '.ciso', '.rvz', '.gcz'}
    EXTENSIONS_WII = {'.iso', '.wbfs', '.ciso', '.rvz', '.gcz'}
    
    # Pattern per estrarre Game ID (es. GLME01, RSPE01)
    # Cerca nei nomi dei file: GLME01, [GLME01], (GLME01), GLME01.iso
    GAME_ID_PATTERN = re.compile(r'([A-Z0-9]{6})')
    
    def __init__(self, game_db=None):
        self.logger = get_logger("scanner")
        self.games = []
        self.gc_paths = []
        self.wii_paths = []
        self.game_db = game_db  # Riferimento al GameDB per metadati
        self._detect_rom_paths()
    
    def _detect_rom_paths(self):
        """Rileva i percorsi delle ROM (GC e Wii)"""
        possible_paths = [
            "/mnt/mmc/ROMS/GC/",
            "/mnt/sdcard/ROMS/GC/",
            "/mnt/mmc/ROMS/Wii/",
            "/mnt/sdcard/ROMS/Wii/",
            "/run/muos/ROMS/GC/",
            "/run/muos/ROMS/Wii/",
        ]
        for path in possible_paths:
            if os.path.isdir(path):
                if "GC" in path or "/gc" in path.lower():
                    if path not in self.gc_paths:
                        self.gc_paths.append(path)
                elif "Wii" in path or "/wii" in path.lower():
                    if path not in self.wii_paths:
                        self.wii_paths.append(path)
        
        # Se non trova percorsi, usa default
        if not self.gc_paths:
            self.gc_paths = ["/mnt/mmc/ROMS/GC/"]
        if not self.wii_paths:
            self.wii_paths = ["/mnt/mmc/ROMS/Wii/"]
        
        self.logger.info(f"GC paths: {self.gc_paths}")
        self.logger.info(f"Wii paths: {self.wii_paths}")
    
    def scan(self, system="all"):
        """Esegue la scansione e restituisce la lista di giochi"""
        self.games = []
        if system in ("all", "gc"):
            self._scan_paths(self.gc_paths, "GC")
        if system in ("all", "wii"):
            self._scan_paths(self.wii_paths, "Wii")
        self.logger.info(f"Scanned {len(self.games)} games")
        return self.games
    
    def _scan_paths(self, paths, system):
        """Scansiona una lista di percorsi per un sistema"""
        for base_path in paths:
            if not os.path.isdir(base_path):
                continue
            for root, dirs, files in os.walk(base_path):
                for file in files:
                    ext = os.path.splitext(file)[1].lower()
                    valid_exts = self.EXTENSIONS_GC if system == "GC" else self.EXTENSIONS_WII
                    if ext in valid_exts:
                        full_path = os.path.join(root, file)
                        game = self._parse_file(full_path, system)
                        if game:
                            # Arricchisci con metadati dal DB
                            if self.game_db:
                                game = self.game_db.enrich_game(game)
                            self.games.append(game)
    
    def _parse_file(self, full_path, system):
        """Analizza un file e restituisce un dizionario con le info"""
        filename = os.path.basename(full_path)
        name, ext = os.path.splitext(filename)
        
        # Cerca Game ID nel nome (in qualsiasi parte)
        id_match = self.GAME_ID_PATTERN.search(name)
        game_id = id_match.group(1) if id_match else None
        
        # Se non trova ID, prova a cercare nel percorso
        if not game_id:
            path_id_match = self.GAME_ID_PATTERN.search(full_path)
            game_id = path_id_match.group(1) if path_id_match else None
        
        # Pulisce il nome: rimuove regioni e ID
        clean_name = name
        if game_id:
            clean_name = clean_name.replace(game_id, "").strip()
        # Rimuove parentesi con regioni (USA), (Europe), etc.
        clean_name = re.sub(r'\([^)]*\)', '', clean_name).strip()
        # Rimuove [ID] eventuali
        clean_name = re.sub(r'\[[^\]]*\]', '', clean_name).strip()
        # Rimuove estensioni strane
        clean_name = re.sub(r'\.iso$|\.wbfs$|\.rvz$', '', clean_name, flags=re.IGNORECASE).strip()
        if not clean_name:
            clean_name = name
        
        # Determina regione dal nome
        region = "Unknown"
        region_markers = {
            "(USA)": "NTSC", "[USA]": "NTSC",
            "(Europe)": "PAL", "[Europe]": "PAL",
            "(Japan)": "NTSC-J", "[Japan]": "NTSC-J",
            "(World)": "World", "[World]": "World",
            "NTSC": "NTSC", "PAL": "PAL",
        }
        for marker, reg in region_markers.items():
            if marker in name:
                region = reg
                break
        
        # Estrae dimensione
        try:
            size_bytes = os.path.getsize(full_path)
            size_mb = size_bytes / (1024 * 1024)
            size_str = f"{size_mb:.1f} MB" if size_mb < 1024 else f"{size_mb/1024:.1f} GB"
        except OSError:
            size_bytes = 0
            size_str = "0 MB"
        
        # Determina se è un gioco Wii o GC dal sistema e dal tipo di file
        is_wii = system == "Wii"
        if ext == ".wbfs":
            is_wii = True
        
        game = {
            "id": game_id,
            "name": clean_name,
            "file_name": filename,
            "path": full_path,
            "system": system,
            "region": region,
            "size": size_str,
            "size_bytes": size_bytes,
            "ext": ext,
            "is_wii": is_wii,
            # Campi che verranno popolati dal GameDB
            "title": None,          # Titolo da GameTDB
            "cover_path": None,     # Percorso copertina
            "rating": None,         # Rating da games.json
            "compatibility": None,  # Label compatibilità
            "compat_color": None,   # Colore compatibilità
            "fps": None,            # FPS da games.json
            "considerations": None, # Note da games.json
            "profile": None,        # Profilo consigliato
        }
        return game