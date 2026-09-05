#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Aggiorna il database games_data.json a partire dal corpo di una issue GitHub.
Struttura attesa del JSON:
{
  "version": 1,
  "last_update": "YYYY-MM-DD",
  "games": [
    {
      "game_info": { "game_id": "...", "system": "...", "game": "...", "region": "..." },
      "entries": [ { ...test report... } ]
    }
  ]
}
"""

import os
import sys
import json
import re
from datetime import datetime

# ---------- Funzione di estrazione ----------
def extract_val(label, body):
    """
    Cerca nel body una riga che inizia con label (case‑insensitive) e restituisce
    il valore dopo i due punti. Gestisce sia ':' che '：' (carattere giapponese).
    """
    pattern = rf'^.*{re.escape(label)}\s*[:：]\s*(.+)$'
    for line in body.splitlines():
        match = re.search(pattern, line, re.IGNORECASE)
        if match:
            return match.group(1).strip()
    return None

# ---------- Lettura variabili d'ambiente ----------
issue_body = os.environ.get('ISSUE_BODY', '')
issue_number = os.environ.get('ISSUE_NUMBER', '')

if not issue_body:
    print("❌ Nessun corpo della issue trovato (ISSUE_BODY vuoto).")
    sys.exit(1)

print(f"📥 Elaborazione issue #{issue_number}")

# ---------- Estrai campi ----------
print("📋 Estrazione campi...")
platform = extract_val("Platform", issue_body) or "GameCube"
game_title = extract_val("Game Title", issue_body)
region = extract_val("Region", issue_body) or "NTSC / USA"
fps_min_raw = extract_val("FPS Range - Minimum", issue_body)
fps_max_raw = extract_val("FPS Range - Maximum", issue_body)
core_profile = extract_val("Core Profile Used", issue_body) or "default"
core_version = extract_val("Dolphin Rt:Core Version", issue_body) or "v10.5.300"
considerations = extract_val("Considerations & Gameplay Experience", issue_body) or ""
tester = extract_val("Tester Username", issue_body) or "Anonymous"
device = extract_val("Device Used", issue_body) or "Unknown Device"
muos_version = extract_val("muOS Version", issue_body) or "2601.1 Funky Jacaranda (current)"
cover_art = extract_val("Cover Art URL", issue_body) or ""

print(f"  📌 Gioco: {game_title}")
print(f"  📌 Piattaforma: {platform}")
print(f"  📌 Regione: {region}")

if not game_title:
    print("❌ Il titolo del gioco è obbligatorio!")
    sys.exit(1)

# ---------- Parse FPS ----------
fps_min = 0
fps_max = 0
fps_str = "???"
if fps_min_raw and fps_max_raw:
    try:
        fps_min = int(fps_min_raw)
        fps_max = int(fps_max_raw)
        fps_str = f"{fps_min} - {fps_max}"
    except ValueError:
        print(f"⚠️ Valori FPS non validi: min={fps_min_raw}, max={fps_max_raw}")

# ---------- Parse Rating ----------
boot_rating_raw = extract_val("Performance Rating", issue_body) or ""
boot = "NO"
rating = 0
if boot_rating_raw:
    # Cerca "N★" (es. "3★")
    match = re.search(r'(\d+)★', boot_rating_raw)
    if match:
        rating = int(match.group(1))
    else:
        # Fallback: cerca qualsiasi numero
        nums = re.findall(r'\d+', boot_rating_raw)
        if nums:
            rating = int(nums[0])
    # Determina boot
    if "NO BOOT" in boot_rating_raw.upper() or "DOESN'T BOOT" in boot_rating_raw.upper():
        boot = "NO"
    else:
        boot = "YES"

# Se rating=0 ma boot=YES, assegna 3★ come default
if rating == 0 and boot == "YES":
    rating = 3

print(f"  ⭐ Rating: {rating}★, Boot: {boot}")

# ---------- Game ID ----------
user_game_id = extract_val("Game ID", issue_body) or ""
game_id = None
note_missing = ""

if user_game_id and re.match(r'[GR][A-Z0-9]{5}', user_game_id):
    game_id = user_game_id.upper()
    print(f"  🆔 Game ID fornito dall'utente: {game_id}")
else:
    # Cerca nel corpo un ID che inizia con G o R e ha 6 caratteri totali
    id_match = re.search(r'[GR][A-Z0-9]{5}', issue_body)
    if id_match:
        game_id = id_match.group(0)
        print(f"  🆔 Game ID trovato nel corpo: {game_id}")
    else:
        # Genera un placeholder
        if game_title:
            clean = re.sub(r'[^a-zA-Z]', '', game_title)[:3].upper()
            game_id = f"{'G' if platform.lower() == 'gamecube' else 'R'}{clean}01"
        else:
            game_id = "UNKNOWN"
        note_missing = f"⚠️ Game ID non rilevato automaticamente. Usato placeholder '{game_id}'."
        print(f"  ⚠️ {note_missing}")

# ---------- Custom Settings ----------
recommend_cs = extract_val("Do you want to recommend Custom Settings?", issue_body) or "No"
custom_settings = []

if recommend_cs.strip().lower() in ["yes", "sì", "si"]:
    cs_type = extract_val("Custom Settings - Type", issue_body) or ""
    cs_name = extract_val("Custom Settings - Name / Title", issue_body) or ""
    cs_url = extract_val("Custom Settings - URL", issue_body) or ""
    cs_details = extract_val("Custom Settings - Details", issue_body) or ""

    # Validazione
    if (cs_type and cs_type != "Select a type..." and cs_name.strip() and len(cs_details.strip()) >= 10):
        custom_settings.append({
            "set_type": cs_type,
            "set_name": cs_name,
            "set_filename": "",
            "set_url": cs_url,
            "set_note": cs_details
        })
        print(f"  ⚙️ Impostazioni personalizzate aggiunte")
    else:
        print(f"  ⚠️ Impostazioni personalizzate saltate: campi obbligatori mancanti")

# ---------- Attachments ----------
attachments = []
attachments_raw = extract_val("Attachments (URLs of screenshots / videos)", issue_body) or ""

if attachments_raw.strip():
    for line in attachments_raw.splitlines():
        line = line.strip()
        if not line:
            continue

        # Separa titolo e URL usando ':' o ' - '
        title = None
        url = line
        for sep in [':', ' - ']:
            if sep in line:
                parts = line.split(sep, 1)
                title = parts[0].strip()
                url = parts[1].strip()
                break

        if not title:
            title = f"Media {len(attachments)+1}"

        # Determina tipo media
        url_lower = url.lower()
        if any(x in url_lower for x in ['youtube.com', 'youtu.be', 'dailymotion', 'vimeo']) or url_lower.endswith(('.mp4', '.webm', '.mov')):
            media_type = "video"
        else:
            media_type = "image"

        attachments.append({
            "media_type": media_type,
            "media_title": title,
            "media_url": url
        })

    print(f"  📎 Trovati {len(attachments)} allegati")

# ---------- Target JSON ----------
json_path = "data/games_data.json"
system = "GC" if platform.lower() == "gamecube" else "Wii"

# Carica il database mantenendo la struttura corretta
if os.path.exists(json_path):
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            db = json.load(f)
        print(f"📂 Database caricato da {json_path}")
    except json.JSONDecodeError as e:
        print(f"❌ Errore decodifica JSON: {e}")
        print("   Creazione nuovo database...")
        db = {"version": 1, "last_update": "", "games": []}
else:
    print(f"📂 {json_path} non trovato, creazione nuovo file")
    os.makedirs(os.path.dirname(json_path), exist_ok=True)
    db = {"version": 1, "last_update": "", "games": []}

# ---------- Costruisci il nuovo entry (test report) ----------
new_entry = {
    "game_info": {
        "game_id": game_id,
        "system": system,
        "game": game_title,
        "region": region
    },
    "test_review": {
        "rating": rating,
        "fps": fps_str,
        "fps_min": fps_min,
        "fps_max": fps_max,
        "boot": boot,
        "playable": "YES" if rating >= 1 else "NO"
    },
    "test_details": {
        "rtcore_version": core_version,
        "core_profile": core_profile,
        "considerations": considerations + ("\n" + note_missing if note_missing else "")
    },
    "test_environment": {
        "tester": tester,
        "device": device,
        "muos_version": muos_version
    },
    "cover_art": cover_art,
    "custom_settings": custom_settings,
    "attachments": attachments
}

# ---------- Cerca o aggiungi il gioco ----------
existing_game = None
for game in db["games"]:
    if game["game_info"]["game_id"] == game_id:
        existing_game = game
        break

if existing_game:
    # Aggiunge il nuovo test report all'array "entries"
    existing_game["entries"].append(new_entry)
    action = "updated"
    print(f"🔄 Aggiunto nuovo test per {game_id} (ora {len(existing_game['entries'])} entry)")
else:
    # Crea un nuovo oggetto gioco
    new_game = {
        "game_info": {
            "game_id": game_id,
            "system": system,
            "game": game_title,
            "region": region
        },
        "entries": [new_entry]
    }
    db["games"].append(new_game)
    action = "added"
    print(f"➕ Aggiunto nuovo gioco {game_id} con il primo test")

# Aggiorna data ultimo aggiornamento
db["last_update"] = datetime.now().strftime("%Y-%m-%d")

# ---------- Salva JSON ----------
try:
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(db, f, indent=2, ensure_ascii=False)
    print(f"✅ JSON salvato con successo ({len(db['games'])} giochi totali)")
except Exception as e:
    print(f"❌ Errore nel salvataggio JSON: {e}")
    sys.exit(1)

# ---------- Imposta variabili d'ambiente per il commit ----------
github_env = os.environ.get('GITHUB_ENV')
if github_env:
    with open(github_env, 'a', encoding='utf-8') as f:
        f.write(f"ACTION={action}\n")
        f.write(f"GAME_ID={game_id}\n")
        f.write(f"GAME_TITLE={game_title}\n")
        f.write(f"TARGET_ISSUE_NUM={issue_number}\n")

print(f"\n✅ {game_title} ({game_id}) {action} con successo.")
if note_missing:
    print(f"⚠️ {note_missing}")
