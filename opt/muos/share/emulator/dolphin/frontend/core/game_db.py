#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GAME DB - Caricamento metadati da games.json, games2.json e wiitdb.txt
"""

import os
import json
import re
from core.logger import get_logger

class GameDB:
    """Carica e fornisce metadati (rating, compatibilità, copertine, ecc.)"""
    
    def __init__(self):
        self.logger = get_logger("game_db")
        self.db = {}          # Mappa game_id -> dati combinati
        self.wiitdb = {}      # Mappa game_id -> dati da wiitdb.txt
        self._load_all()
    
    def _load_all(self):
        """Carica tutte le fonti di dati"""
        self._load_compatibility_db()  # games.json e games2.json
        self._load_wiitdb()            # wiitdb.txt
    
    def _load_compatibility_db(self):
        """Carica i file games.json e games2.json"""
        frontend_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        db_dir = os.path.join(frontend_root, "data", "database")
        
        # Cerca i file nella directory data/database
        json_files = [
            os.path.join(db_dir, "games.json"),
            os.path.join(db_dir, "games2.json")
        ]
        
        for json_file in json_files:
            if os.path.isfile(json_file):
                try:
                    with open(json_file, 'r', encoding='utf-8') as f:
                        data = json.load(f)
                        if isinstance(data, list):
                            for entry in data:
                                game_id = entry.get("game_id")
                                if game_id:
                                    # Se già esiste, mergiamo
                                    if game_id in self.db:
                                        self.db[game_id].update(entry)
                                    else:
                                        self.db[game_id] = entry
                        elif isinstance(data, dict):
                            for key, entry in data.items():
                                game_id = entry.get("game_id", key)
                                if game_id in self.db:
                                    self.db[game_id].update(entry)
                                else:
                                    self.db[game_id] = entry
                        self.logger.info(f"Loaded compatibility data from {json_file}")
                except Exception as e:
                    self.logger.warning(f"Failed to load {json_file}: {e}")
    
    def _load_wiitdb(self):
        """Carica il database wiitdb.txt per titoli e informazioni generali"""
        frontend_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        db_path = os.path.join(frontend_root, "data", "database", "wiitdb.txt")
        
        if not os.path.isfile(db_path):
            self.logger.warning(f"wiitdb.txt not found at {db_path}")
            return
        
        try:
            with open(db_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Pattern per estrarre le voci: ID = Titolo
            # Es: "RSPE01 = Wii Sports"
            pattern = re.compile(r'^([A-Z0-9]{6})\s*=\s*(.+?)$', re.MULTILINE)
            
            for match in pattern.finditer(content):
                game_id = match.group(1)
                title = match.group(2).strip()
                self.wiitdb[game_id] = {
                    "id": game_id,
                    "title": title,
                    "source": "wiitdb"
                }
            
            self.logger.info(f"Loaded {len(self.wiitdb)} entries from wiitdb.txt")
        except Exception as e:
            self.logger.warning(f"Failed to load wiitdb.txt: {e}")
    
    def get_metadata(self, game_id):
        """Restituisce i metadati combinati per un Game ID"""
        result = {}
        
        # Prima i dati da wiitdb (titolo)
        if game_id in self.wiitdb:
            result.update(self.wiitdb[game_id])
        
        # Poi i dati da games.json (rating, compatibilità, ecc.)
        if game_id in self.db:
            result.update(self.db[game_id])
        
        return result if result else None
    
    def get_title(self, game_id):
        """Restituisce il titolo del gioco da GameTDB o None"""
        if game_id and game_id in self.wiitdb:
            return self.wiitdb[game_id].get("title")
        return None
    
    def get_rating(self, game_id):
        """Restituisce il rating (0-5) o None"""
        meta = self.get_metadata(game_id)
        if meta:
            return meta.get("rating")
        return None
    
    def get_compatibility_label(self, game_id):
        """Restituisce la label di compatibilità (Perfect, Great, ecc.)"""
        rating = self.get_rating(game_id)
        if rating is None:
            return "Unknown"
        labels = {
            5: "PERFECT",
            4: "GREAT",
            3: "PLAYABLE",
            2: "POOR",
            1: "BAD",
            0: "UNPLAYABLE",
        }
        return labels.get(rating, "Unknown")
    
    def get_compatibility_color(self, game_id):
        """Restituisce il colore (RGB) per la compatibilità"""
        rating = self.get_rating(game_id)
        if rating is None:
            return (100, 100, 100)  # Grigio
        colors = {
            5: (0, 255, 120),      # Verde brillante
            4: (136, 255, 136),    # Verde chiaro
            3: (255, 204, 0),      # Giallo
            2: (255, 136, 0),      # Arancione
            1: (255, 0, 68),       # Rosso
            0: (150, 150, 150),    # Grigio scuro
        }
        return colors.get(rating, (100, 100, 100))
    
    def get_cover_url(self, game_id):
        """Restituisce l'URL della copertina da GameTDB"""
        # GameTDB usa URL: https://art.gametdb.com/wii/cover/US/{game_id}.png
        # Per GameCube: https://art.gametdb.com/gc/cover/US/{game_id}.png
        if not game_id:
            return None
        
        # Determina il sistema dal Game ID (prime 2 lettere)
        # G = GameCube, R = Wii
        prefix = game_id[0] if len(game_id) > 0 else ""
        if prefix == "R":
            return f"https://art.gametdb.com/wii/cover/US/{game_id}.png"
        else:
            return f"https://art.gametdb.com/gc/cover/US/{game_id}.png"
    
    def enrich_game(self, game):
        """Arricchisce un dizionario gioco con metadati dal DB"""
        game_id = game.get("id")
        if not game_id:
            return game
        
        meta = self.get_metadata(game_id)
        if not meta:
            return game
        
        # Aggiunge titolo se presente
        if "title" in meta and meta["title"] and not game.get("title"):
            game["title"] = meta["title"]
        
        # Aggiunge rating e compatibilità
        rating = self.get_rating(game_id)
        if rating is not None:
            game["rating"] = rating
            game["compatibility"] = self.get_compatibility_label(game_id)
            game["compat_color"] = self.get_compatibility_color(game_id)
        
        # Aggiunge FPS e note
        if "fps" in meta:
            game["fps"] = meta["fps"]
        if "considerations" in meta:
            game["considerations"] = meta["considerations"]
        if "core" in meta:
            game["profile"] = meta.get("core")
        if "playable" in meta:
            game["playable"] = meta["playable"]
        
        # Aggiunge URL copertina
        game["cover_url"] = self.get_cover_url(game_id)
        
        return game