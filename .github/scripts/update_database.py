import json
import os
import re
import datetime

def parse_rating(rating_str):
    """Extract numeric rating from string (e.g., '3★ - BOOTS WITH ISSUES' -> 3)."""
    if not rating_str:
        return 0
    match = re.search(r'(\d+)', rating_str)
    return int(match.group(1)) if match else 0

def determine_playable(rating):
    """Determine playable status based on rating."""
    if rating <= 2:
        return "NO"
    elif rating == 3:
        return "WITH ISSUES"
    else:
        return "YES"

def main():
    # Path to the games data JSON file (relative to repository root)
    json_path = "data/games_data.json"
    
    # Path to the parsed issue JSON from GitHub Action (stefanbuck/github-issue-parser)
    issue_data_path = os.getenv("ISSUE_DATA_PATH", "issue.json")
    
    if not os.path.exists(issue_data_path):
        print(f"Error: Issue data file not found at {issue_data_path}")
        return

    with open(issue_data_path, "r", encoding="utf-8") as f:
        issue_fields = json.load(f)

    # Extract and normalize fields from the issue form
    platform_raw = issue_fields.get("platform", "GameCube")
    system_code = "Wii" if "Wii" in platform_raw else "GC"
    
    game_title = issue_fields.get("game_title", "Unknown Game").strip()
    region = issue_fields.get("region", "PAL").strip()
    game_id = issue_fields.get("game_id", "").strip().upper()
    
    # Fallback game_id generation if empty
    if not game_id:
        game_id = re.sub(r'[^A-Z0-9]', '', game_title.upper())[:6]

    rating_str = issue_fields.get("boot_rating", "")
    rating = parse_rating(rating_str)
    
    try:
        fps_min = int(issue_fields.get("fps_min", 0))
    except ValueError:
        fps_min = 0
        
    try:
        fps_max = int(issue_fields.get("fps_max", 0))
    except ValueError:
        fps_max = 0
        
    fps_str = f"{fps_min}-{fps_max}"
    boot_status = "NO" if rating == 0 else "YES"
    playable_status = determine_playable(rating)

    # Core details & environment
    core_profile = issue_fields.get("core_profile", "Default")
    rtcore_version = issue_fields.get("core_version", "v10.5.3 (current)")
    considerations = issue_fields.get("considerations", "").strip()
    
    tester = issue_fields.get("tester", "Anonymous").strip()
    device = issue_fields.get("device", "Unknown Device").strip()
    muos_version = issue_fields.get("muos_version", "").strip()
    cover_art = issue_fields.get("cover_art", "").strip()

    # Custom settings handling
    custom_settings = []
    cs_enabled = issue_fields.get("custom_settings_enabled", "No")
    if cs_enabled == "Yes":
        custom_settings.append({
            "type": issue_fields.get("custom_settings_type", "Config"),
            "name": issue_fields.get("custom_settings_name", ""),
            "url": issue_fields.get("custom_settings_url", ""),
            "details": issue_fields.get("custom_settings_details", "")
        })

    # Attachments parsing (one URL per line)
    attachments_raw = issue_fields.get("attachments", "")
    attachments = [line.strip() for line in attachments_raw.splitlines() if line.strip()]

    # Construct the new entry object
    new_game_info = {
        "game_id": game_id,
        "system": system_code,
        "game": game_title,
        "region": region
    }

    new_entry = {
        "game_info": new_game_info,
        "test_review": {
            "rating": rating,
            "fps": fps_str,
            "boot": boot_status,
            "playable": playable_status,
            "fps_min": fps_min,
            "fps_max": fps_max
        },
        "test_details": {
            "rtcore_version": rtcore_version,
            "core_profile": core_profile,
            "considerations": considerations
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

    # Load existing database or initialize a new one
    if os.path.exists(json_path):
        with open(json_path, "r", encoding="utf-8") as f:
            db = json.load(f)
    else:
        db = {"version": 1, "last_update": "", "games": []}

    # Find if the game already exists in the database
    existing_game = next((g for g in db["games"] if g["game_info"]["game_id"] == game_id), None)

    if existing_game:
        # Append the new test entry to the existing game record
        existing_game["entries"].append(new_entry)
    else:
        # Create a new game entry group
        db["games"].append({
            "game_info": new_game_info,
            "entries": [new_entry]
        })

    # Update database timestamp
    db["last_update"] = datetime.date.today().strftime("%Y-%m-%d")

    # Save back to the JSON file cleanly
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(db, f, indent=4, ensure_ascii=False)
    
    print(f"Successfully updated database for game: {game_title} (ID: {game_id})")

if __name__ == "__main__":
    main()
