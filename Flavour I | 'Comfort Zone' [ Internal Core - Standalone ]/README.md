<h1 align="center">
  <img src="https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/blob/main/assets/Dolphin_RtCore_Flavour1_ComfortZone_Boxart.jpeg?raw=true" alt="Comfort Zone Boxart" width="350" align="left" style="margin-right: 20px; margin-bottom: 15px;">
  Flavour I: <u>Comfort Zone</u>
</h1>

<p align="center">
  <a href="https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest">
    <img src="https://img.shields.io/badge/Dolphin%20Rt:Core-v11.5.00-8C59F2?style=for-the-badge&logo=github" alt="Version">
  </a>
  <img src="https://img.shields.io/badge/platform-muOS-4FA8C7?style=for-the-badge&logo=linux" alt="Platform">
  <img src="https://img.shields.io/badge/flavour-comfort%20zone-4CC850?style=for-the-badge" alt="Flavour">
</p>

> ### :zap: **TL;DR — Straight to the point**
> ***Only straight gaming sessions, zero setting nightmares.***
> Comfort Zone is the **no-configuration** flavour of Dolphin Rt:Core. **Seven battle-tested profiles, automatic bloom removal, curated per-game tweaks, HD texture pack included.** Assign, launch, play. :video_game:
<br clear="all">

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/ticket.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> The Edition — What Comfort Zone Is

  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinrt_icon.png" alt="Rt:Core Branding" width="80" align="left" style="margin-right: 20px; margin-bottom: 15px;">

**Comfort Zone** is the *zero-friction* flavour of Dolphin Rt:Core. It is built for one purpose: **let you play, without touching a single option**.

Everything is decided for you in advance — profiles, mods, controller layouts, textures, exit behaviour. The package ships with the sweet spot already dialled in. You assign the core to a ROM folder from muOS Content Explorer, pick a profile from a dropdown, and the game boots with everything it needs.

* :white_check_mark: **No adjusters, no tiers, no configuration screens.**
* :white_check_mark: **No scripts to run, no menus to open.**
* :white_check_mark: **No decisions — just gameplay.**

If you want knobs to turn, that is Flavour II (*Bash Arsenal*). Comfort Zone is the *baseline* — the way Rt:Core is meant to be *just played*.
<br clear="all">

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/star.png" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> The Seven Profiles

Every profile in Comfort Zone ships with **JITARM64 forced** (`CPUCore = 4`) and **async shader compilation** (`ShaderCompilationMode = 3`) — the two single biggest performance wins on H700 hardware.

| Profile | Character | Best For |
| :--- | :--- | :--- |
| 🚀 **Performance** | Daily driver, balanced | **90%** of your library |
| 🔰 **Compatibility** | Accuracy first, slower | Problematic titles |
| 🛸 **Rintromping** | Speed first, aggressive | Lightweight games |
| ⚡ **Speed Hacks** | Extra hack flags enabled | Heavy 3D titles |
| 🖥️ **Black Screen Fix** | GPU sync enforced | Games that refuse to boot |
| 🎯 **Sweet Spot** | Custom-tuned balance | Personal favourite |
| ⛩️ **Default** | Baseline reference, no tuning | Debugging / fallback |

Each is available for **GameCube** (upright) and **Wii** (upright + sideways). Choose once from Content Explorer → Assign Core. Done.

---

## 💡 Automatic Bloom Removal

The single biggest FPS gain available on H700 hardware — **enabled by default, for every game**.

* **What it does:** strips the post-processing *bloom* pass — a full-screen GPU blur applied after every frame.
* **Performance impact:** **+2 to +5 FPS** on most 3D titles, with a measurable drop in heat generation.
* **Configuration required:** none. It is active from the first launch.

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/CNK.png" alt="Crash Nitro Kart icon" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Crash Nitro Kart — HD Texture Pack Included

A curated **HD Texture Pack** for *Crash Nitro Kart* is bundled inside Comfort Zone.

* **What it does:** replaces the stock low-resolution textures with sharp HD assets. It also fixes the notorious **C4 texture tiling artifacts** — the corrupted button prompts and character icons that affect every GameCube release of the game.
* **Footprint:** only **5.7 MB** — negligible impact on RAM, zero impact on framerate.
* **Status:** :white_check_mark: **Active out of the box.**
* **Source:** [Dolphin Forums — Crash Nitro Kart HD Texture Fixes](https://forums.dolphin-emu.org/Thread-crash-nitro-kart-hd-texture-fixes)

Crash Nitro Kart is one of the smoothest GameCube experiences on H700 — this pack makes it look the way it deserves.

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/orbcore.png" alt="Game Tweaks icon" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Curated Per-Game Tweaks

Ten heavy 3D titles ship with **targeted Depth-of-Field (DOF) removal**, already enabled. DOF is a screen-space blur that runs after the render pass — skipping it eliminates a full-screen GPU cost per frame on titles that struggle most.

| Game Title | Optimization Applied |
| :--- | :--- |
| 🏎️ **Crash Nitro Kart** | DOF Removal + HD Texture Pack |
| 🏎️ **Crash Tag Team Racing** | DOF Removal |
| 🌪️ **Crash Bandicoot: Wrath of Cortex** | DOF Removal |
| 🐉 **Dragon Ball Z: Budokai** | DOF Removal |
| 🐉 **Dragon Ball Z: Budokai 2** | DOF Removal |
| 🍄 **Super Mario Sunshine** | DOF Removal |
| 🎯 **Scaler** | DOF Removal |
| 🛸 **Metroid Prime** | DOF Removal |
| 🥊 **Super Smash Bros. Melee** | DOF Removal |
| ⚽ **Mario Smash Football** | DOF Removal |

No configuration. No toggles to hunt down. It is applied automatically when the game boots.

---

## <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/powerup_machine.png" alt="Game Settings icon" width="50" align="left" style="margin-right: 20px; margin-bottom: 15px;"> Empiric GameSettings — Hand-Tuned Engine Overrides

Comfort Zone ships **twelve pre-configured `GameSettings` files** targeting known engine bottlenecks on the H700. These are not guesses — they come from real testing on real hardware, documented in each file's header.

| GameID | Title | Engine Fix Applied |
| :--- | :--- | :--- |
| `G4QE01` | Super Mario Strikers | Underclock 0.40 |
| `GKUE01` | Scaler | Underclock 0.40 |
| `GLMP01` | Luigi's Mansion | Underclock 0.40 |
| `GMSP01` / `GMSE01` | Super Mario Sunshine | EFB Access + 0.60 Underclock |
| `GDBP69` / `GDBE69` | Dragon Ball Z: Budokai | XFB Fix + 0.60 Underclock |
| `GZ3P69` / `GZ3E69` | Dragon Ball Z: Budokai 2 | XFB Fix + 0.55 Underclock |
| `GCBP7D` / `GCBE7D` | Crash: Wrath of Cortex | XFB Fix + 0.50 Underclock |
| `GOWP69` | Need for Speed: Most Wanted | Underclock 0.50 |

Every file includes region, override rationale, and expected FPS in its header.

---

## 🗝️ Native Exit Hotkey

Press **START + SELECT** at any moment to terminate Dolphin instantly and return to muOS.

* :white_check_mark: No menus to navigate.
* :white_check_mark: No prompt dialogs to dismiss.
* :white_check_mark: No leftover background processes.

This was a **long-missing feature** in every previous Dolphin build for H700 — the only way out used to be rebooting the device. Comfort Zone closes the loop.

---

## 🔗 Reference

Comfort Zone inherits from the Rt:Core ecosystem. For the community-maintained **Compatibility Database** — 200+ benchmarked titles with star ratings, FPS ranges, and recommended profiles — see:

🔗 **[silvercrow2323.github.io/Dolphin-Core-for-MuOS](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)**

For **installation instructions, ROM formats, hardware requirements, and general project documentation**, refer to the main Rt:Core README.

---

## 🙏🏻 Credits & Acknowledgments

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/sirpips.jpeg" alt="sirpips" width="110" style="border-radius: 50%; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
  <br>
  <b>sirpips aka SilverCrow2323</b>
  <br>
  <i>SPDW Factory Lab</i>
</p>

| Contributor / Project | Contribution |
| :--- | :--- |
| 🐬 **Dolphin Emulator Team** | Upstream emulation core & backend engine |
| 🏭 **SPDW Factory Lab / sirpips** | Comfort Zone edition design, profile tuning, mod packaging |
| 💾 **muOS Development Team** | Operating system framework and launch scripts |
| 👥 **Dolphin Community** | Graphics mod tweaks & HD texture bugfixes |

---

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/spdw_symbol.png" alt="SPDW Symbol" width="50" style="vertical-align: middle; margin-right: 10px;">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinrt_icon.png" alt="Dolphin Rt Icon" width="50" style="vertical-align: middle;">
  <br><br>
  <i>Dolphin Rt:Core v11.5.00 — Flavour I: Comfort Zone.</i><br>
  <b><u>Still Sbrobbing. Always Rintromping.</u></b> :video_game:
</p>
