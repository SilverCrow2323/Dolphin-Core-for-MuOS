import os
import json
import re

# Percorso del file JSON nel tuo repository
JSON_PATH = "games_data.json"

def parse_issue_body(body_text):
    """Estrae i campi chiave dal corpo della issue generata dal template markdown."""
    data = {}
    
    # Rimuove i caratteri di ritorno a capo superflui
    body_text = body_text.replace("\r\n", "\n")
    
    # Pattern per estrarre le sezioni basate su ### o ## e il testo successivo
    # Sfruttiamo le intestazioni della issue template
    sections = {
        "platform": r"### Platform \*\n\n(.*?)(?=\n\n###|\Z)",
        "game_title": r"### Game Title \*\n\n(.*?)(?=\n\n###|\Z)",
        "region": r"### Region \*\n\n(.*?)(?=\n\n###|\Z)",
        "game_id": r"### Game ID \(optional\)\n\n(.*?)(?=\n\n###|\Z)",
        "cover_art": r"### Cover Art URL \(optional\)\n\n(.*?)(?=\n\n###|\Z)",
        "boot_rating": r"### Performance Rating \*\n\n(.*?)(?=\n\n###|\Z)",
        "fps_min": r"### FPS Range - Minimum \*\n\n(.*?)(?=\n\n###|\Z)",
        "fps_max": r"### FPS Range - Maximum \*\n\n(.*?)(?=\n\n###|\Z)",
        "core_profile": r"### Core Profile Used \*\n\n(.*?)(?=\n\n###|\Z)",
        "considerations": r"### Considerations & Gameplay Experience\n\n(.*?)(?=\n\n###|\Z)",
        "custom_settings_enabled": r"### Do you want to recommend Custom Settings\?\n\n(.*?)(?=\n\n###|\Z)",
        "custom_settings_type": r"### Custom Settings - Type\n\n(.*?)(?=\n\n###|\Z)",
        "custom_settings_name": r"### Custom Settings - Name / Title\n\n(.*?)(?=\n\n###|\Z)",
        "custom_settings_url": r"### Custom Settings - URL \(optional\)\n\n(.*?)(?=\n\n###|\Z)",
        "custom_settings_details": r"### Custom Settings - Details\n\n(.*?)(?=\n\n###|\Z)",
        "attachments": r"### Attachments \(URLs of screenshots / videos\)\n\n(.*?)(?=\n\n###|\Z)",
        "tester": r"### Tester Username \*\n\n(.*?)(?=\n\n###|\Z)",
        "device": r"### Device Used \*\n\n(.*?)(?=\n\n###|\Z)",
        "muos_version": r"### muOS Version \*\n\n(.*?)(?=\n\n###|\Z)",
        "core_version": r"### Dolphin Rt:Core Version \*\n\n(.*?)(?=\n\n###|\Z)"
    }
    
    for key, pattern in sections.items():
        match = re.search(pattern, body_text, re.DOTALL)
        if match:
            val = match.group(1).strip()
            # GitHub Forms a volte mette "_No response_" se il campo è vuoto
            if val == "_No response_" or not val:
                val = ""
            data[key] = val
        else:
            data[key] = ""
            
    return data

def main():
    issue_body = os.environ.get("ISSUE_BODY", "")
    if not issue_body:
        print("Nessun corpo della issue trovato.")
        return

    parsed = parse_issue_body(issue_body)
    
    # Elaborazione Piattaforma e Sistema
    platform_input = parsed.get("platform", "GameCube")
    system_code = "Wii" if "Wii" in platform_input else "GC"
    
    game_title = parsed.get("game_title", "Unknown Game").strip()
    region = parsed.get("region", "PAL").strip()
    game_id = parsed.get("game_id", "").strip()
    if not game_id:
        # Fallback ID generico se non inserito
        game_id = "GENERIC"
        
    cover_art = parsed.get("cover_art", "").strip()
    
    # Rating (es: "4★ - BOOTS & PLAYABLE...") -> estraiamo il numero iniziale
    rating_raw = parsed.get("boot_rating", "3")
    rating_num = int(rating_raw[0]) if rating_raw and rating_raw[0].isdigit() else 3
    
    boot_status = "YES" if rating_num > 0 else "NO"
    playable_status = "YES" if rating_num >= 4 else ("YES WITH ISSUES" if rating_num == 3 else "NO")
    
    try:
        fps_min = int(parsed.get("fps_min", "0"))
    except ValueError:
        fps_min = 0
        
    try:
        fps_max = int(parsed.get("fps_max", "0"))
    except ValueError:
        fps_max = 0
        
    fps_str = f"{fps_min}-{fps_max}" if fps_min != fps_max else str(fps_min)
    
    # Costruzione della nuova entry strutturata come il JSON esistente
    new_entry = {
        "game_info": {
            "game_id": game_id,
            "system": system_code,
            "game": game_title,
            "region": region
        },
        "test_review": {
            "rating": rating_num,
            "fps": fps_str,
            "boot": boot_status,
            "playable": playable_status,
            "fps_min": fps_min,
            "fps_max": fps_max
        },
        "test_details": {
            "rtcore_version": parsed.get("core_version", ""),
            "core_profile": parsed.get("core_profile", ""),
            "considerations": parsed.get("considerations", "")
        },
        "test_environment": {
            "tester": parsed.get("tester", "Anonymous"),
            "device": parsed.get("device", ""),
            "muos_version": parsed.get("muos_version", "")
        },
        "cover_art": cover_art,
        "custom_settings": [],
        "attachments": []
    }
    
    # Gestione Custom Settings opzionali
    cs_enabled = parsed.get("custom_settings_enabled", "").lower()
    if "yes" in cs_enabled:
        cs_type = parsed.get("custom_settings_type", "Config")
        if cs_type == "Select a type..." or not cs_type:
            cs_type = "Config"
            
        custom_setting_obj = {
            "set_type": cs_type,
            "set_name": parsed.get("custom_settings_name", "Custom Config"),
            "set_filename": f"{game_id}.ini",
            "set_url": parsed.get("custom_settings_url", ""),
            "set_note": parsed.get("custom_settings_details", "")
        }
        new_entry["custom_settings"].append(custom_setting_obj)
        
    # Gestione Attachments opzionali (uno per riga)
    attachments_raw = parsed.get("attachments", "")
    if attachments_raw:
        lines = attachments_raw.split("\n")
        for line in lines:
            url = line.strip()
            if url:
                media_type = "video" if "youtu" in url or "mp4" in url else "image"
                attachment_obj = {
                    "media_type": media_type,
                    "media_title": "Attachment from test report",
                    "media_url": url
                }
                new_entry["attachments"].append(attachment_obj)

    # Caricamento del database JSON esistente
    if os.path.exists(JSON_PATH):
        with open(JSON_PATH, "r", encoding="utf-8") as f:
            db = json.load(f)
    else:
        db = {"version": 1, "last_update": "", "games": []}
        
    # Cifre/Ricerca se il gioco esiste già nel database per game_id e region
    found_game = None
    for game_group in db.get("games", []):
        g_info = game_group.get("game_info", {})
        if g_info.get("game_id") == game_id and g_info.get("region") == region:
            found_game = game_group
            break
            
    if found_game:
        # Aggiunge l'entry al gruppo esistente
        found_game.setdefault("entries", []).append(new_entry)
    else:
        # Crea un nuovo blocco di gioco
        new_game_group = {
            "game_info": {
                "game_id": game_id,
                "system": system_code,
                "game": game_title,
                "region": region
            },
            "entries": [new_entry]
        }
        db.setdefault("games", []).append(new_game_group)
        
    # Aggiorna la data dell'ultimo aggiornamento (puoi usare datetime se preferisci)
    import datetime
    db["last_update"] = datetime.date.today().isoformat()
    
    # Scrittura formattata nel file JSON
    with open(JSON_PATH, "w", encoding="utf-8") as f:
        json.dump(db, f, indent=2, ensure_ascii=False)
        
    print("Database aggiornato con successo!")

if __name__ == "__main__":
    main()
