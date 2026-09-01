<div align="center">

# <img src="assets/spdw_symbol.png" width="30" alt="SPDW Symbol"> Dolphin Rt:Core for MuOS

**Central hub about the development of GameCub and Wii emulation on muOS.**  
*A handheld running an ARM SoC deserves to squeeze every drop of performance out for the Mecha-Dolphin!!*

[![muOS](https://img.shields.io/badge/muOS-Compatible-7B68EE?style=flat-square)](#)
[![Device](https://img.shields.io/badge/Device-RG35XX--H-FF6F00?style=flat-square)](#)
[![Emulation](https://img.shields.io/badge/Core-Dolphin-3776AB?style=flat-square&logo=nintendo-gamecube&logoColor=white)](#)
[![SPDW Factory](https://img.shields.io/badge/SPDW_Factory_Lab-00FFCC?style=for-the-badge)](#)
[![Latest Release](https://img.shields.io/github/v/release/SilverCrow2323/Dolphin-Core-for-MuOS?style=flat-square&label=Latest%20Release&color=00A3E0)](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest)

<br>

<img src="assets/dolphinformuos.png" width="700" alt="Dolphin for muOS Banner">

<br><br>
</div>

## 📊 Compatibility Database

A brand new, interactive compatibility database is now live! It gathers and organizes all test results performed across previous core versions into a detailed, searchable format complete with user ratings and performance metrics:

### 🌐 [Dolphin Rt:Core for muOS - Interactive Compatibility List](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)

The database features:
- **GameCube & Wii** compatibility ratings
- **FPS metrics** for each tested game
- **Regional coverage** (NTSC, PAL, JPN)
- **Core profile recommendations**
- **Search and filter** functionality
- **Detailed test entries** with notes and configurations

### 🧪 Contribute Your Results

Want to contribute to the chaos? If you test other titles, feel free to share your results by opening a new issue using our dedicated GameCube and Wii Test Template:

- 🎮 [SEND YOUR TEST REPORT](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/issues/new?template=dolphin-rt-core-test-report.yml)

---

## 📜 Overview

Stock firmware gives you basic emulation and stops there. Thanks to **muOS**, fortunately, countless doors of possibility are thrown wide open. It provides an effective and highly functional environment that significantly elevates the quality of these portable consoles—often of dubious (or entirely unknown) origins—pushing them to heights we thought impossible for a 200g pocket-sized contraption. **Dolphin Core** is one of those peaks.

The goal of **Dolphin Rt:Core** — now included as part of the **[V0iD Project]** by **SPDW Factory** — starts from a different premise: running GameCube and Wii on an **H700 chipset** requires surgical precision, relentless testing, and custom optimization profiles. We are actively working on this core with the specific aim of pushing the hardware to its absolute limits (and maybe a little beyond) to offer a genuinely pleasant and playable experience for the GameCube catalog and, albeit much more difficult, the Wii library.

---

## ⚙️ Key Features & Performance

### 🎮 15+ Optimized Profiles

| Profile | Description | Best For |
|---------|-------------|----------|
| `performance` | Maximum FPS, reduced quality | 3D games needing speed |
| `compatibility` | Stability-first, DualCore disabled | Games that crash or glitch |
| `troubleshooting` | Balanced "best of both worlds" | Most games (recommended default) |
| `lite` | Ultra-low resolution | 2D games, maximum speed |
| `widescreen` | 16:9 with balanced quality | Games with widescreen support |
| `debug` / `logger` | Diagnostic modes | Troubleshooting & reporting |
| `blackscreenfix` | Fixes black screen issues | Games that freeze on boot |

**Wii-specific profiles:**
- `wii-performance` - For lighter Wii games
- `wii-compatibility` - For problematic Wii titles
- `wii-safe` - Ultra-conservative, "last resort" profile

### ⌨️ Under Development: Global Hotkey System

All hotkeys are centralized and work across **every profile**.  
Gamepad combos are translated by `gptokeyb` on the RG35XX H:

| Action | Combo | Key Sent |
|--------|-------|----------|
| **Graceful Exit** | `Menu` + `Start` | `ESC` |
| **Force Exit** | `Start` + `Select` + `Menu` | `killall dolphin` |
| **Save State 1** | `Menu` + `L1` | `F1` |
| **Load State 1** | `Menu` + `R1` | `Shift+F1` |
| **Save State 2** | `Menu` + `L2` | `F2` |
| **Load State 2** | `Menu` + `R2` | `Shift+F2` |
| **Toggle FPS** | `Menu` + `D-Pad Up` | `F9` |
| **Toggle Pause** | `Menu` + `D-Pad Down` | `F10` |
| **Toggle Stats** | `Menu` + `D-Pad Left` | `F11` |
| **Toggle Speed** | `Menu` + `D-Pad Right` | `F12` |
| **Toggle OSD** | `Menu` + `A` | `F8` |
| **Reset** | `Menu` + `B` | `F6` |
| **Fullscreen** | `Menu` + `X` | `F5` |

### 🗂️ Per-Game Settings

Dolphin automatically loads `GameSettings/{GAME_ID}.ini` when a game is launched.  
This allows you to fine-tune individual games without affecting others.

Example (`GameSettings/G8MP01.ini` for Paper Mario):
```ini
[Core]
CPUThread = False
Overclock = 0.85
```

### 🎯 Optimized for H700 (1GB RAM)

- `InternalResolution` set to `0.5`–`0.75` (never `50` or `60`!)
- `ShaderCompilationMode = 1` (Synchronous) for stability
- `EFBToTextureEnable = True` to save VRAM
- `DisableFog = True` for FPS boost
- `SafeTextureCacheColorSamples = 0` for maximum performance

### 🔧 General Optimizations
- **Strategic Underclocking:** Fine-tuning parameters like `Overclock` to reduce virtual CPU load and prevent audio stuttering on the H700 chipset.
- **Adaptive Scaling:** Resolution adjustments and precise graphic flag management (`ImmediateXFBEnable`, `EFBToTextureEnable`) to maintain playable frame rates.
- **Visual Glitch Prevention:** Strict handling of `VISkip` to avoid breaking rendering engines on complex scenes.
- 💡 **PAL TIP:** If you are struggling to squeeze every single frame out of your handheld, **always look for PAL ROMs**. Running natively at **50fps** (instead of 60fps NTSC) drastically reduces the processing load on the core, often making the difference between an unplayable slideshow and a remarkably smooth experience.

---

## 📁 Directory Structure

All Dolphin data is centralized under `/opt/muos/share/emulator/dolphin/`:

```
dolphin/
├── Config/                     # All configuration files
│   ├── Dolphin.ini             # Active config (copied from profile)
│   ├── Dolphin.performance.ini # Profile files
│   ├── Dolphin.compatibility.ini
│   ├── Dolphin.wii-performance.ini
│   ├── ...
│   ├── Hotkeys.ini             # Global hotkeys (shared across profiles)
│   ├── GCPadNew.ini            # GameCube controller
│   ├── WiimoteNew.ini          # Wii Remote
│   └── Profiles/               # Controller profiles (optional)
│
├── GameDumps/                  # Texture & frame dumps
│   ├── GameCube/
│   └── Wii/
│
├── Resources/                  # Custom textures & mods
│   ├── GameCube/
│   └── Wii/
│
├── Save/                       # Game saves & NAND
│   ├── GameCube/
│   │   ├── MemcardA/
│   │   └── MemcardB/
│   ├── Wii/
│   │   ├── NAND/
│   │   └── sd.raw
│   └── GBA/
│
└── GameSettings/               # Per-game configs (auto-loaded)
    ├── GLME01.ini
    ├── G8MP01.ini
    └── ...
```

---

## 📥 Installation Guide

### Prerequisites
- **muOS** installed on your device (tested on RG35XX H)

### Quick Install via .muxupd

1. **Download the Release:** Fetch the latest package file (`.muxupd`) from the **[Releases](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest)** section.
2. **Transfer to Device:** Place the downloaded file into the `ARCHIVE` folder on either **`SD1`** or **`SD2`**.
3. **Open Archive Manager:** On your console, navigate to **Applications** ➔ **Archive Manager** inside muOS.
4. **Execute Install:** Select the downloaded file and launch the installation process.

### Manual Setup (if needed)
```bash
# Clone the repository
git clone https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS.git

# Copy all files to the Dolphin directory
sudo cp -r Dolphin-Core-for-MuOS/opt/muos/share/emulator/dolphin/* /opt/muos/share/emulator/dolphin/

# Set up profile assignments
sudo cp -r "Nintendo GameCube" /opt/muos/share/info/assign/
sudo cp -r "Nintendo Wii" /opt/muos/share/info/assign/
```

---

## 📖 Usage Guide

1. **Navigate to Content:** Open **Content Explorer** from the main muOS menu.
2. **Locate Your Games:** Browse to the directory where you stored your Nintendo GameCube or Nintendo Wii ROMs.
3. **Assign Core Profile:** Match the game (or folder) with one of the available Dolphin core profiles:
   - `Dolphin Rt:Core` — Standard balanced profile
   - `Dolphin Rt:Core [Performance]` — Maximum speed
   - `Dolphin Rt:Core [Compatibility]` — Stability-first
   - `Dolphin Rt:Core [Troubleshooting]` — Best of both
   - `Dolphin Rt:Core [Lite]` — Ultra-lightweight
   - `Dolphin Rt:Core [Widescreen]` — 16:9 optimized
   - `Dolphin Rt:Core / Wii [Performance]` — Wii speed
   - `Dolphin Rt:Core / Wii [Compatibility]` — Wii stability
   - `Dolphin Rt:Core / Wii [Safe]` — Wii "last resort"
4. **Launch & Play:** Boot up the title and test the performance!

> ⚠️ **IMPORTANT NOTE ON EXITING THE EMULATOR:**  
> Dedicated in-core hotkeys to directly exit Dolphin are still under development and in an experimental state. To safely exit the emulator you can use the default muOS hotkey:  
> 👉 **`L2` + `R2` + `Start`** (**Restart your device**)  

---

## 🛠️ Tips & Tricks

### For Best Performance
- **Use PAL ROMs** — They run at 50 FPS instead of 60, giving a significant speed boost
- **Start with `Troubleshooting`** — It's the most balanced profile for most games
- **Try `Lite` for 2D games** — Games like *Paper Mario* or *Wario Ware* should run better
- **Disable `wideScreenHack`** if you see visual glitches
- **Create per-game configs** for problematic titles or to test your custom configuration (`GameSettings/{GAME_ID}.ini`)

### Debugging a Game
1. Use the `Debug` profile — It uses the interpreter (slower but more accurate)
2. Enable `Logger` profile — Captures detailed logs
3. Check logs at `/opt/muos/share/emulator/dolphin/GameDumps/`
4. Check muOS logs via `LOG_INFO` in the launcher script

---

## 📝 Upcoming

> 💡 **Something is brewing behind the scenes...**
>
> A new frontend experience is in development — built from the ground up for muOS, designed to bring a modern, intuitive interface to Dolphin on handhelds. Stay tuned!

---

## 🤝 Credits & Acknowledgments

Part of the **SPDW Factory** ecosystem, created by **Sir Pips**.

<div align="center">
  <img src="assets/spdwfactory_logo.png" width="250" alt="SPDW Factory Logo">
  <br><br>
  <img src="assets/spdw_symbol.png" width="60" alt="SPDW Symbol">
</div>

<br>

This project stands upon the shoulders of the talented developers and community pioneers who made GameCube emulation on H700 handhelds a reality — as initially explored and documented in the official [muOS Community Discussion for Dolphin V9](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491):

### 🐬 Original Dolphin Core Developers

- **@Speedrun** ([Speedrun [+.[🐬].%]](https://community.muos.dev/u/speedrun)) — Original author of the Dolphin port for muOS (V9 / Take 3)
- **@FireBattleInMtl** ([@FireBattleInMtl](https://community.muos.dev/u/firebattleinmtl)) — Huge thanks for all changes after V8, fixing permissions, and creating the script to add Dolphin to muOS' `launch.sh`
- **@Snow** ([@Snow](https://community.muos.dev/u/snow)) (SnowV8) — For providing the newly compiled Dolphin binary file
- **@bitter_bizarro** ([@bitter_bizarro](https://community.muos.dev/u/bitter_bizarro)) — For adopting the core and making it compatible with muOS Goose!
- **@razorbeamz**, **@arkun**, **@SkiffguardLando**, **@chronoss0109**, **@Kirky**, **@Mikethe3ird**, **@Symphonial**, **@giodude**, **@lasagnesetting**, **@joshuarcastillo** — For testing, reporting issues, and improving the core
- **muOS Development Team** — For ongoing firmware maintenance and structural support

> *Check out the [Core History Archive](Core_History/) to browse legacy builds (V7, V8, V9) and read up on their evolution.*

---

### 📋 Game Compatibility Database Contributors

The original game compatibility list, which served as the foundation for the Rt:Core database, was created and maintained by the community:
- **@Sexy_Shrek**
- **@SkullXavier**
- **@S1eepy**
- **@Danster21**
- **@eleot**
- **@Lucaspec72**
- **@Mercquick**
- **@Row**
- **@Speedrun [+.[🐬].%]**
- **@ᴡᴏᴋᴇᴜ𝒑ɪɴᴘᴀʀɪs**
- **@sirpips** (data processing and database maintenance)
- **@Luis Torrão** (per-game configuration testing)
- **@TekkraGMD** (Wii testing)
- **@Happy** (game testing)
- **@DeadPlant** (legacy testing)
- **@SEIRO** (legacy testing)

### 🌐 Community

The muOS community is vibrant and welcoming. You can find us here:

- [muOS Community Forum](https://community.muos.dev) — The main hub for discussions, support, and announcements
- [muOS Discord](https://discord.gg/muos) — For real-time chat, testing discussions, and direct support
- [muOS Website](https://muos.dev) — Official project page and documentation

A special thanks to **duncanyoyo** and other Discord members who helped with the transition to the new muOS core structure.

---


> ℹ️ **IMPORTANT DISCLAIMER & COMMUNITY ACKNOWLEDGMENT**  
> This repository is **not** an original core built from scratch. Full credit for porting and pioneering GameCube/Wii emulation on muOS goes to the **original community developers**. This project represents a **fine-tuning, optimization, and repository management effort** built directly upon their foundation.


## 📜 License

This project is open-source and licensed under the **MIT License**.

---

## 🔗 Links

- [GitHub Repository](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS)
- [Latest Release](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest)
- [Compatibility Database](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)
- [muOS Documentation](https://muos.dev)
- [Dolphin Emulator](https://dolphin-emu.org)
- [GameTDB](https://gametdb.com) — Cover art and game metadata

---

<div align="center">

  <img src="assets/minoru_symbol.png" width="80" alt="Minoru Symbol">
  <br>
  *-Keep up the Sbrobbing. And forever Rintromping.*

</div>
