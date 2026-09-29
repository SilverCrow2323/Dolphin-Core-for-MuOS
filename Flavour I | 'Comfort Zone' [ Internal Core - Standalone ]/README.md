<p align="center">
<img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphin_title.png" alt="Dolphin Rt:Core Banner" width="90%">
</p>

<h1 align="center">🐬 Dolphin Rt:Core</h1>
<h2 align="center">🛋️ Flavour 1: <b><u>Comfort Zone</u></b> — v11.5.00</h2>

<p align="center">
  <img src="https://img.shields.io/badge/version-11.5.00-8C59F2?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/platform-muOS-4FA8C7?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/badge/status-stable-4CC850?style=for-the-badge" alt="Status">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/spdwfactory_logo.png" alt="SPDW Factory" width="180">
  <br>
  <b>SPDW Factory Lab</b> / <code>sirpips aka SilverCrow2323</code>
</p>

---

> ### ⚡ **TL;DR — For those who want to get straight to the point:**
>
> ***Only straight gaming sessions, no setting nightmares.***
> Plug in, assign, play. **Seven battle-tested profiles, automatic bloom removal, curated per-game tweaks, HD texture pack for Crash Nitro Kart included.** Zero Python, zero bloat. 🎮

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinformuos.png" alt="Dolphin for muOS" width="70%">
  <br>
  <i>Fig. 1 — Dolphin Rt:Core running seamlessly inside the muOS ecosystem.</i>
</p>

---

## 📖 Overview

**Comfort Zone** is the *streamlined* edition of Dolphin Rt:Core, built for the **RG35XX H / Allwinner H700** family of handhelds running **muOS**.

It gives you a **fully configured** Dolphin emulator that integrates directly with the muOS **Content Explorer**:

- 🗂️ **Assign a core** to your GameCube or Wii ROM folder
- 🎮 **Pick a profile** from the Content Explorer menu
- ▶️ **Play** — Dolphin boots with the right settings, controllers, mods, and textures

No extra tools. No menus. No scripts to run manually. Everything works through the **standard muOS launch flow**.

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/rtcore.png" alt="Rt:Core Branding" width="50%">
</p>

---

## 🎯 What's Included

### 🚀 Seven Ready-to-Use Profiles

Every profile ships with **JITARM64 forced** and **async shader compilation** for the best possible performance.

| Profile | Description | Best For |
| --- | --- | --- |
| 🚀 **performance** | Daily driver, balanced | 90% of games |
| 🛡️ **compatibility** | Accuracy first | Problematic titles |
| 💨 **rintromping** | Maximum speed | Lightweight games |
| ⚡ **speedhacks** | Extra hack flags | Heavy 3D titles |
| 🖥️ **blackscreenfix** | GPU sync forced | Won't-boot games |
| 🎯 **sweetspot** | Custom-tuned balance | Personal favorite |
| 🏠 **default** | Baseline reference | Debug / fallback |

Available for **GameCube** (upright) and **Wii** (upright + sideways).

---

### 🎨 Automatic Bloom Removal

The single biggest FPS win on H700 — **enabled by default** for all games.

**What it does:** removes the *bloom* post-processing effect, a full-screen blur applied after rendering. Skipping it eliminates one GPU pass per frame.

**Impact:** +2–5 FPS on most 3D titles. Zero configuration needed.

---

### 🏎️ Crash Nitro Kart — HD Texture Pack Included

A curated **HD texture pack** for Crash Nitro Kart is bundled with Comfort Zone.

**What it does:** replaces the game's original textures with higher-resolution versions, fixing the notorious **C4 texture tiling artifacts** that affect buttons and character icons on all GameCube versions. It also sharpens the overall visual quality of the game.

**Size:** 5.7 MB — negligible impact on H700 performance.

**Source:** [Dolphin Forums — Crash Nitro Kart HD Texture Fixes](https://forums.dolphin-emu.org/Thread-crash-nitro-kart-hd-texture-fixes)

**Status:** ✅ **Active by default** — no configuration needed.

> 💡 **Note:** The pack includes texture fixes for all regions (GCN, GCNE7D, GCNP7D). Dolphin automatically applies them to any Crash Nitro Kart ROM.

---

### 🎯 Curated Per-Game Tweaks

For the heaviest titles, we've added **per-game Depth-of-Field removal** — automatically applied only to those games.

| Game | Optimization |
| --- | --- |
| 🏎️ Crash Nitro Kart | DOF Removal + HD Textures |
| 🏎️ Crash Tag Team Racing | DOF Removal |
| 💥 Crash Bandicoot: Wrath of Cortex | DOF Removal |
| 🐉 Dragon Ball Z: Budokai | DOF Removal |
| 🐉 Dragon Ball Z: Budokai 2 | DOF Removal |
| 🍄 Super Mario Sunshine | DOF Removal |
| 🎯 Scaler | DOF Removal |
| 👽 Metroid Prime | DOF Removal |
| 🥊 Super Smash Bros. Melee | DOF Removal |
| ⚽ Mario Smash Football | DOF Removal |

**These are already active.** Nothing to configure. Just play.

---

### 🎮 GameSettings — 12 Hand-Tuned Overrides

Dolphin's own per-game config files, curated for known problem titles:

| GameID | Title | Fix Applied |
| --- | --- | --- |
| `G4QE01` | Super Mario Strikers | Underclock 0.40 |
| `GKUE01` | Scaler | Underclock 0.40 |
| `GLMP01` | Luigi's Mansion | Underclock 0.40 |
| `GMSP01` / `GMSE01` | Super Mario Sunshine | EFB access + 0.60 |
| `GDBP69` / `GDBE69` | DBZ Budokai | XFB fix + 0.60 |
| `GZ3P69` / `GZ3E69` | DBZ Budokai 2 | XFB fix + 0.55 |
| `GCBP7D` / `GCBE7D` | Crash: Wrath of Cortex | XFB fix + 0.50 |
| `GOWP69` | NFS Most Wanted | Underclock 0.50 |

Every file is documented in its header with region, reason, and expected FPS.

---

### 🚪 Native Exit Hotkey

Press **START + SELECT** to exit Dolphin instantly and return to muOS.

**That's it.** No menus, no combos to remember, no in-game dialogs to dismiss.

---

## 📦 Supported ROM Formats

`ISO` · `GCM` · `RVZ` · `WBFS`

**🏆 Recommended: RVZ** with **Zstandard compression, level 5**

| Parameter | Value |
| --- | --- |
| **Format** | `RVZ` |
| **Algorithm** | Zstandard (zstd) |
| **Compression Level** | `5` |
| **Block Size** | `128 KiB` |

> ⚠️ **Avoid LZMA** — smaller files, but too CPU-heavy for H700.

---

## 🚀 Installation

### 📥 From `.muxupd` package (recommended)

| Step | Action |
| --- | --- |
| **1** | Download `Dolphin_RtCore_v11.5.00_ComfortZone.muxupd` |
| **2** | Copy to `/mnt/mmc/ARCHIVE/` (SD1) or `/mnt/sdcard/ARCHIVE/` (SD2) |
| **3** | On muOS: **Applications → Archive Manager** |
| **4** | Select the `.muxupd` and start the installation |
| **5** | Wait — everything is installed automatically ✅ |

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/muos_post.png" alt="muOS Installation" width="60%">
  <br>
  <i>Fig. 2 — Archive Manager handles the entire installation flow.</i>
</p>

---

## 🎮 Usage

1. From muOS, open **Content Explorer** 🗂️
2. Navigate to your **GameCube** or **Wii** ROM folder
3. Press **X** → **Assign Core** 🧩
4. Select **Nintendo GameCube** or **Nintendo Wii**
5. Pick a profile from the list (7 available)
6. Launch any game — the core is now assigned to that folder 🔗

> 💡 **Tip:** If a game runs poorly, check the **Compatibility List** first.

---

## 🛡️ Compatibility List

A curated community compatibility database with 200+ tested titles:

🔗 **[silvercrow2323.github.io/Dolphin-Core-for-MuOS](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)**

Each entry includes:

- ⭐ Star rating (1–5)
- 📊 FPS range
- 🎯 Recommended profile
- 🔧 Known issues

---

## 🗑️ Uninstall

Two ways to remove everything cleanly:

**Option A — From RtSys:**

```bash
bash /opt/muos/share/emulator/dolphin/RtSys/uninstall_dolphinrt.sh
```

**Option B — From muOS Task Toolkit:**

Go to **Applications → Task Toolkit → Dolphin RtCore → Eradicate da Dolpheen**

Both remove:

- `/opt/muos/share/emulator/dolphin/`
- `/opt/muos/share/info/assign/Nintendo Gamecube/`
- `/opt/muos/share/info/assign/Nintendo Wii/`
- `/opt/muos/share/task/Dolphin Rt*`
- `/opt/muos/script/launch/ext-dolphin.sh`
- `/opt/muos/script/launch/ext-dolphinrt.sh`
- `/opt/muos/share/emulator/gptokeyb/ext-dolphin-gptk`

And generate a visual report.

---

## 📝 Notes

- ⚠️ **GameCube fonts required** for some titles (like NFS: Most Wanted): ensure `Sys/GC/font_western.bin` and `Sys/GC/font_japanese.bin` are present, otherwise the game will show a **black screen on boot**
- 🎨 **HD texture pack for Crash Nitro Kart is included** — no setup needed
- 🐍 **No Python subsystem** — the pad is read natively by SDL
- 🌸 **Bloom Removal is always active** — no configuration needed
- 📊 **Only 2 log files** — `launcher_report.log` (overwritten each session) and `watcher.log` (append)
- 🖥️ **H700 is not enough for Dolphin.** This is a **technical demonstration**, not a plug-and-play emulator. Realistic expectations:
  - Lightweight 2D games: 30–50 FPS
  - Medium 3D games: 15–25 FPS
  - Heavy 3D games (NFS, Crash, Zelda): 5–15 FPS

> 🛠️ For **advanced control** *(profile adjusters, mod toggles, in-game overlays)*, see ***Flavour 2: Bash Arsenal***

---

## 🙏 Credits

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/sirpips.jpeg" alt="sirpips" width="120" style="border-radius: 50%;">
  <br>
  <b>sirpips aka SilverCrow2323</b> — SPDW Factory Lab
</p>

| Credit | Role |
| --- | --- |
| 🐬 **Dolphin Emulator** | Core emulation software |
| 🏭 **SPDW Factory Lab / sirpips** | muOS integration, configuration, packaging, Graphics Mods, GameSettings, HD Texture Pack |
| 🎛️ **muOS team** | Operating system and launch framework |
| 🎨 **Dolphin community** | Graphics Mods reference, HD texture fixes |

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/spdw_symbol.png" alt="SPDW Symbol" width="15%">
</p>

---

<p align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinrt_icon.png" alt="Dolphin Rt Icon" width="15%">
  <br><br>
  <i>Dolphin Rt:Core v11.5.00 — Flavour 1: Comfort Zone.</i><br>
  <b><u>Still Sbrobbing. Always Rintromping.</u></b> 🎮
</p>