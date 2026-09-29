<h1 align="center"><img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinformuos.png" alt="Rt:Core Branding" width="250" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Flavour 1: <u>Comfort Zone</u></h1>

<p align="center">
  <a href="https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest">
    <img src="https://img.shields.io/badge/version-11.5.00-8C59F2?style=for-the-badge&logo=github" alt="Version">
  </a>
  <img src="https://img.shields.io/badge/platform-muOS-4FA8C7?style=for-the-badge&logo=linux" alt="Platform">
  <img src="https://img.shields.io/badge/status-stable-4CC850?style=for-the-badge" alt="Status">
</p>

---


> ### :zap: **TL;DR — Straight to the point**
>
> ***Only straight gaming sessions, zero setting nightmares.***
> Plug in, assign, play. **Seven battle-tested profiles, automatic bloom removal, curated per-game tweaks, and HD texture pack for Crash Nitro Kart included.** Zero Python overhead, zero bloat. :video_game:


</div>

<br clear="all">

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/ticket.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Overview

<div>
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/mechadolphin.png" alt="Rt:Core Branding" width="150" align="left" style="margin-right: 20px; margin-bottom: 15px;">

**Comfort Zone** is the *streamlined* edition of Dolphin Rt:Core, built for the **RG35XX H / Allwinner H700** family of handhelds running **muOS**.

It provides a **fully configured** Dolphin emulator that integrates directly with the muOS **Content Explorer**:

* 🔹 **Assign a core** to your GameCube or Wii ROM folder.
* :video_game: **Pick a profile** directly from the Content Explorer menu.
* :arrow_forward: **Play** — Dolphin boots with tuned settings, correct controllers, graphics mods, and textures.

No extra menus. No manual scripts to execute. Everything flows through the **standard muOS launch framework**.
</div>

<br clear="all">

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/star.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> What's Included

### > Seven Ready-to-Use Profiles

Every profile ships with **JITARM64 forced** (`CPUCore = 4`) and **async shader compilation** for maximum FPS and stutter-free gameplay.

| Profile | Description | Best For |
| :--- | :--- | :--- |
| :rocket: **performance** | Daily driver, balanced | **90%** of games |
| :shield: **compatibility** | Accuracy first | Problematic titles |
| :dash: **rintromping** | Maximum speed, aggressive hacks | Lightweight games |
| :zap: **speedhacks** | Extra performance flags | Heavy 3D titles |
| :desktop_computer: **blackscreenfix** | GPU sync forced | Games that fail to boot |
| :target: **sweetspot** | Custom-tuned balance | Personal favorite |
| :house: **default** | Baseline reference | Debugging / fallback |

> *Available for **GameCube** (upright) and **Wii** (upright + sideways).*

---

### > Automatic Bloom Removal

The single biggest FPS gain on H700 hardware — **enabled by default** across all games.

* **What it does:** Strips out the heavy post-processing *bloom* blur effect. Bypassing bloom eliminates an entire GPU rendering pass per frame.
* **Performance Impact:** **+2 to +5 FPS** on most 3D titles with lower heat generation.

---

### <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/CNK.png" alt="Crash Nitro Kart icon" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Crash Nitro Kart — HD Texture Pack Included

Comfort Zone includes a pre-packaged **HD Texture Pack** specifically optimized for *Crash Nitro Kart*.

* **What it does:** Replaces low-res stock textures with sharp HD assets, resolving the infamous **C4 texture tiling artifacts** (corrupted button prompts and character icons) present on GameCube hardware.
* **Footprint:** Only **5.7 MB** — negligible impact on RAM and performance.
* **Status:** :white_check_mark: **Active out of the box** — zero setup required.
* **Source:** [Dolphin Forums — Crash Nitro Kart HD Texture Fixes](https://forums.dolphin-emu.org/Thread-crash-nitro-kart-hd-texture-fixes)

> [!TIP]
> The texture pack includes automatic region matching for all GameCube ROMs (`GCN`, `GCNE7D`, `GCNP7D`).
</div>

<br clear="all">

---

### <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/orbcore.png" alt="Game Tweaks icon" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Curated Per-Game Tweaks

Heavy 3D titles receive targeted **Depth-of-Field (DOF) removal** to maintain smooth framerates.

| Game Title | Optimization Applied |
| :--- | :--- |
| :racing_car: **Crash Nitro Kart** | DOF Removal + HD Texture Pack |
| :racing_car: **Crash Tag Team Racing** | DOF Removal |
| :boom: **Crash Bandicoot: Wrath of Cortex** | DOF Removal |
| :dragon: **Dragon Ball Z: Budokai** | DOF Removal |
| :dragon: **Dragon Ball Z: Budokai 2** | DOF Removal |
| :mushroom: **Super Mario Sunshine** | DOF Removal |
| :target: **Scaler** | DOF Removal |
| :alien: **Metroid Prime** | DOF Removal |
| :boxing_glove: **Super Smash Bros. Melee** | DOF Removal |
| :soccer: **Mario Smash Football** | DOF Removal |

---

### <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/powerup_machine.png" alt="Game Settings icon" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> GameSettings — Hand-Tuned Engine Overrides

Pre-configured `GameSettings` files targeting known engine bottlenecks:

| GameID | Title | Engine Fix Applied |
| :--- | :--- | :--- |
| `G4QE01` | Super Mario Strikers | Underclock 0.40 |
| `GKUE01` | Scaler | Underclock 0.40 |
| `GLMP01` | Luigi's Mansion | Underclock 0.40 |
| `GMSP01` / `GMSE01` | Super Mario Sunshine | EFB Access + 0.60 Underclock |
| `GDBP69` / `GDBE69` | DBZ Budokai | XFB Fix + 0.60 Underclock |
| `GZ3P69` / `GZ3E69` | DBZ Budokai 2 | XFB Fix + 0.55 Underclock |
| `GCBP7D` / `GCBE7D` | Crash: Wrath of Cortex | XFB Fix + 0.50 Underclock |
| `GOWP69` | Need for Speed: Most Wanted | Underclock 0.50 |

---

### > Native Exit Hotkey

Press **START + SELECT** anytime to terminate Dolphin instantly and safely return to muOS.

* No awkward menu combos.
* No prompt dialogs.
* No leftover background processes.

---

## :package: Supported ROM Formats

Supports `ISO`, `GCM`, `RVZ`, and `WBFS`.

### <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/trophy.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Recommended Format: **RVZ (Zstandard, Level 5)**

| Parameter | Recommended Setting |
| :--- | :--- |
| **Format** | `RVZ` |
| **Compression Algorithm** | `Zstandard (zstd)` |
| **Compression Level** | `5` |
| **Block Size** | `128 KiB` |

> [!WARNING]
> **Avoid LZMA compression** — while it produces slightly smaller files, it severely taxes the H700 CPU during gameplay reads.

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/engine.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Installation

<div>

1. Download `Dolphin_RtCore_v11.5.00_ComfortZone.muxupd`.
2. Copy the file to your SD card:
   * SD1: `/mnt/mmc/ARCHIVE/`
   * SD2: `/mnt/sdcard/ARCHIVE/`
3. On your muOS handheld, go to **Applications :arrow_right: Archive Manager**.
4. Select the `.muxupd` package to begin automatic installation.

<i>Fig. 2 — Installation via muOS Archive Manager.</i>
</div>

<br clear="all">

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/Question_sticker.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> How to Use

1. Open **Content Explorer** in muOS.
2. Navigate to your **GameCube** or **Wii** ROM directory.
3. Press **X** :arrow_right: **Assign Core**.
4. Choose **Nintendo GameCube** or **Nintendo Wii**.
5. Select one of the **7 available profiles**.
6. Launch your game — the selected profile is now permanently linked to that directory.

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/id.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Compatibility Database

Browse our community compatibility database with 200+ benchmarked games:

<img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinrt_icon.png" width="40" align="left" style="margin-right: 20px; margin-bottom: 15px;">  **[Official Compatibility List](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)**

Each listing details:
* :star: Star Playability Rating (1–5)
* :bar_chart: Average FPS
* :target: Recommended Profile
* :wrench: Workarounds & Configuration Notes

---

## :wastebasket: Uninstallation

To cleanly remove Dolphin Rt:Core:

* **Method A (Terminal/RtSys):**
  ```bash
  bash /opt/muos/share/emulator/dolphin/RtSys/uninstall_dolphinrt.sh
  ```
* **Method B (muOS Task Toolkit):**
  Navigate to **Applications :arrow_right: Task Toolkit :arrow_right: Dolphin RtCore :arrow_right: Eradicate da Dolpheen**.

Both methods remove all associated binaries, launch wrappers, shortcuts, and core assignments cleanly.

---

## :memo: Technical Notes & Hardware Reality

> [!IMPORTANT]
> **H700 Performance Context:**
> The Allwinner H700 is at the absolute lower boundary for GameCube/Wii emulation. Dolphin Rt:Core is an optimized **technical accomplishment**, not a 100% full-speed solution.
> * **Lightweight 2D Games:** 30–50 FPS (Playable)
> * **Medium 3D Games:** 15–25 FPS (Fair / Playable with frameskip)
> * **Heavy 3D Games:** 5–15 FPS (Benchmark only)

* **GameCube Fonts Required:** Certain titles (e.g., *NFS: Most Wanted*) require font files (`Sys/GC/font_western.bin` and `Sys/GC/font_japanese.bin`) inside the Dolphin system directory to prevent booting into a black screen.
* **Native Input Reading:** Pure C/SDL input handler. Python dependencies have been completely removed.
* **Minimal Disk I/O:** Logging is restricted to two files (`launcher_report.log` overwritten per session, and `watcher.log`) to preserve SD card endurance.

---

## :pray: Credits & Acknowledgments

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/sirpips.jpeg" alt="sirpips" width="110" style="border-radius: 50%; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
  <br>
  <b>sirpips aka SilverCrow2323</b>
  <br>
  <i>SPDW Factory Lab</i>
</p>

| Contributor / Project | Contribution |
| :--- | :--- |
| :dolphin: **Dolphin Emulator Team** | Upstream emulation core & backend engine |
| :factory: **SPDW Factory Lab / sirpips** | muOS architecture integration, profiling, graphics mods & packaging |
| :control_knobs: **muOS Development Team** | Operating system framework and launch scripts |
| :palette: **Dolphin Community** | Graphics mod tweaks & HD texture bugfixes |

---

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/spdw_symbol.png" alt="SPDW Symbol" width="50" style="vertical-align: middle; margin-right: 10px;">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinrt_icon.png" alt="Dolphin Rt Icon" width="50" style="vertical-align: middle;">
  <br><br>
  <i>Dolphin Rt:Core v11.5.00 — Flavour 1: Comfort Zone.</i><br>
  <b><u>Still Sbrobbing. Always Rintromping.</u></b> :video_game:
</p>
