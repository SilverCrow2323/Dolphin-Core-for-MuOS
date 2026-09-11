<div align="center">

# <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Dolphin_Emulator_Logo_Refresh.svg/250px-Dolphin_Emulator_Logo_Refresh.svg.png" width="30" alt="Dolphin Logo"> Dolphin Rt:Core for muOS

**GameCube and Wii emulation on muOS handhelds, tuned for the Allwinner H700.**  
*Made by people who got tired of "playable" meaning "seventeen frames per second".*

[![muOS](https://img.shields.io/badge/muOS-Compatible-7B68EE?style=flat-square)](https://muos.dev)
[![SoC](https://img.shields.io/badge/SoC-Allwinner%20H700-FF6F00?style=flat-square)](#)
[![Core](https://img.shields.io/badge/Core-Dolphin-3776AB?style=flat-square&logo=nintendo-gamecube&logoColor=white)](https://dolphin-emu.org)
[![SPDW Factory](https://img.shields.io/badge/SPDW_Factory_Lab-00FFCC?style=for-the-badge)](#)
[![Latest Release](https://img.shields.io/github/v/release/SilverCrow2323/Dolphin-Core-for-MuOS?style=flat-square&label=Latest%20Release&color=00A3E0)](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest)

<br>

<img src="assets/dolphinformuos.png" width="700" alt="Dolphin for muOS Banner">

<br><br>

*One emulator. Three flavors. Zero corporate bullshit.*

</div>

---

## 🚪 Pick Your Path

| | Edition | Status | What it is |
|:---:|---|:---:|---|
| **01** | [**Rt:Core 'Standalone'**](01_RtCore_Standalone/) | ✅ `v11.0.00` | The core, and nothing else. Drop-in external emulator for muOS. |
| **02** | [**Rt:Core 'Bash Arsenal'**](02_RtCore_BashArsenal/) | ✅ `v11.0.00` | Standalone + 21 tuned profiles, 17 toggles, Graphics Mods, logs, reports. |
| **03** | [**Rt:Core 'Frontendone'**](03_RtCore_Frontendone/) | 🚧 `soon` | Full frontend. Library, workshop, hub, dashboards. The whole circus. |

📊 **[Interactive Compatibility Database](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)** — game-by-game results, FPS metrics, recommended profiles. Contribute your own tests via the [Issue Template](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/issues/new?template=dolphin-rt-core-test-report.yml).

---

## Yo, listen.

Stock firmware gives you emulation and calls it a day. muOS tears the door off the hinges and lets you actually do something with these 200-gram plastic bricks. **Dolphin Rt:Core** is one of those somethings.

Running GameCube and Wii on an **H700** (RG35XX-H, RG40XX-H, RG CubeXX and friends) is not a "just install and play" situation. It's a tuning job. It's surgical. It's arguing with a 1 GB RAM budget at 2 AM, cutting a shader here, dropping a fog effect there, and somehow getting 58 FPS out of a game that had no business running on this chip.

That is what this repo is: **the argument, won.** Three editions, one philosophy — get the Mecha-Dolphin to squeeze out every last drop.

---

## 🧠 The H700 Method

Before we get to the fun stuff, understand the constraints:

- **SoC:** Allwinner H700 (quad Cortex-A53 + Mali-G31)
- **RAM:** 1 GB, shared between CPU, GPU, and the emulator itself
- **GPU:** Mali-G31 MP2 — not a desktop-class part, not even close
- **Display:** 640×480 (RG35XX-H) to 720×720 (RG CubeXX)

Dolphin was built for desktop GPUs with gigabytes of VRAM. To make it fly here, we operate on three levers:

1. **Resolution scaling** — render at native or below. Anything higher is a slideshow.
2. **Effect removal** — Fog, Bloom, Depth of Field, HUD: gone. They eat VRAM for free.
3. **Timing and sync** — underclock the virtual CPU, relax the GPU sync, let the emulator breathe.

Everything else — shader compilation mode, texture cache sampling, EFB handling — follows from those three rules.

---

## ⚙️ Base Settings (H700 tuned)

These are the settings our profiles settle on. Every edition ships with them; the Bash Arsenal lets you push them ±3 in either direction.

### `Dolphin.ini` — emulation core

| Key | Base | Why |
|---|---|---|
| `CPUCore` | `1` | JIT64 recompiler. The only sane choice. |
| `CPUThread` | `True` | Runs the CPU emulation on a separate thread. Free FPS. |
| `EnableIdleSkipping` | `True` | Skips idle loops. Big win on games that spin. |
| `SyncGPU` | `False` *(perf)* / `True` *(compat)* | Off = faster, on = accurate. Profiles decide. |
| `Overclock` | `0.80` – `1.00` | Strategic *under*clock: less virtual CPU load, less stutter. |
| `TimingVariance` | `40` – `60` | Tolerates frame stalls without audio pops. |
| `FastDiscSpeed` | `True` | Fake DVD drive speed. Games don't notice, we win. |
| `Framelimit` | `1` | 60 FPS cap (auto). Prevents runaway speeds. |
| `SkipIPL` | `True` | Skips the GameCube boot animation. Faster to gameplay. |

### `GFX.ini` — graphics

| Key | Base | Why |
|---|---|---|
| `Backend` | `Vulkan` | Faster than OpenGL on Mali. Always. |
| `InternalResolution` | `1` (native) | Never above. The H700 cannot afford more. |
| `ShaderCompilationMode` | `1` (Sync) | Async causes stutter on weak CPUs. Sync is safer. |
| `DisableFog` | `True` *(perf)* / `False` *(compat)* | Free FPS, loses atmosphere. Profiles decide. |
| `FastDepthResult` | `True` | Faster depth buffer. |
| `EFBToTextureEnable` | `True` | Renders EFB to texture, not RAM. Saves VRAM. |
| `SkipEFBCopyToRam` | `True` | Skips RAM copies. Big win, occasional glitches. |
| `DeferEFBCopies` | `True` | Batches EFB copies. Faster, less accurate. |
| `XFBToTextureEnable` | `True` | XFB to texture instead of RAM. |
| `FastTextureSampling` | `True` | Faster texture filter. Slight quality hit. |
| `SafeTextureCacheColorSamples` | `0` | Fastest texture cache mode. |
| `EnableGraphicsMods` | `True` | Enables the Graphics Mods system (bloom/DOF/HUD removal). |

> 💡 **Tuning Tip:** **Edition 02 (Bash Arsenal)** gives you 7 levels per profile, so you can push speed up to MAX or accuracy down to MIN without ever editing an INI by hand.

---

## 🎁 Extra Sauce

### 💡 PAL ROMs are your friend

A GameCube/Wii game running in **PAL** mode targets **50 FPS**, not 60. That's a 17% reduction in per-frame work — often the difference between "stuttering mess" and "smooth as butter" on H700. When a title exists in both regions, try PAL first.

### 📦 Use RVZ. Seriously.

`.iso` and `.gcm` files waste gigabytes of space and read from storage slower. **RVZ** (Dolphin's native compressed format) is:

- **~60–70% smaller** than ISO
- **Faster to read** (better cache behavior)
- **Lossless** — if done right, zero quality loss

Conversion is one command from Dolphin's CLI:

\`\`\`bash
./dolphin-tool convert -i "Your Game.iso" -o "Your Game.rvz" -f rvz -b 131072 -c zstd -l 5
\`\`\`

**Recommended conversion settings for H700:**

| Flag | Value | Meaning |
|:---:|:---:|---|
| `-f` | `rvz` | RVZ output format |
| `-b` | `131072` | 128 KiB block size (fast decompression) |
| `-c` | `zstd` | zstd compression (fast + good ratio) |
| `-l` | `5` | Compression level 5 (balance) |

*Do not use `-l 9` — it compresses harder but the H700 spends more CPU time decompressing on the fly, negating the benefit. Level 5 is the sweet spot.*

### 🎮 Game Settings per title

Dolphin reads `GameSettings/<GAMEID>.ini` per game. If a title needs `Overclock = 0.85` and `DisableFog = False` while everything else wants the global profile, that's where you put it. No need to switch profiles just for one stubborn game.

---

## 📁 Folder Structure

Every edition uses the same base layout under `/opt/muos/share/emulator/dolphin/`:

\`\`\`text
dolphin/
├── Config/                     # all .ini configuration files
│   ├── Dolphin.ini             # active emulation config
│   ├── Dolphin.ini.compatibility
│   ├── Dolphin.ini.performance
│   ├── Dolphin.ini.sweetspot
│   ├── GFX.ini                 # active graphics config
│   ├── GFX.ini.compatibility
│   ├── GFX.ini.performance
│   ├── GFX.ini.sweetspot
│   ├── GCPadNew.ini
│   ├── WiimoteNew.ini
│   ├── Hotkeys.ini
│   └── Logger.ini
├── GameSettings/               # per-game overrides (auto-loaded)
│   └── <GAMEID>.ini
├── GC/                         # GameCube memory cards and saves
├── Wii/                        # Wii NAND and saves
├── Load/
│   └── GraphicMods/            # Graphics Mods (bloom/DOF/HUD removal)
├── dolphin                     # emulator binary
└── [rtdata/]                   # (only in Editions 02 and 03)
\`\`\`

**Editions 02 and 03** add:

\`\`\`text
rtdata/
├── logs/                       # session logs, reports, overview
├── pocket_workshop/            # 21 profile presets (3 × 7 levels)
├── graphic_mods/               # Graphics Mods sources
├── profiles_preset/            # factory reset snapshots
└── rt_keyinject.py, rt_joywatch.py
\`\`\`

And a new **Task Toolkit** entry under muOS:

\`\`\`text
Dolphin Rt:Core/
├── Profiles/                   # apply tuned profiles
├── Toggles/                    # 17 runtime toggles
├── Graphic Mods/               # install/remove Graphics Mods
└── View Status.sh, View Logs.sh, Restore Profiles.sh, Uninstall Dolphin.sh
\`\`\`

---

## 🎮 The Three Flavors

### 01 — Rt:Core 'Standalone' ✅

> **The core, and nothing else.**

Drop-in external emulator for muOS. Installs Dolphin as a selectable core in **Content Explorer**, ships with three profiles (**Sweet Spot**, **Compatibility**, **Performance**), and gets out of your way.

- One `.muxupd` package, installed via Archive Manager.
- Three profiles, selectable from the muOS core list.
- No menus, no scripts, no workshop. Just play.
- Compatible with `ext-dolphin.sh` (launch script) and standard `Nintendo GameCube`/`Nintendo Wii` assign files.

**Best for:** people who want to press Play.

📖 **[Read the full Standalone README →](01_RtCore_Standalone/)**

---

### 02 — Rt:Core 'Bash Arsenal' ✅

> **The power-user edition. Total control from the muOS task menu.**

Everything from Standalone, plus a full tuning toolkit that lives inside muOS's own **Task Toolkit**. No extra app. No GUI. Just a new folder called **Dolphin Rt:Core** with more knobs than you'll ever need.

**Included:**
- 🎚️ **21 profiles** — 3 base profiles × 7 intensity levels (MIN → MAX).
- 🔀 **17 toggles** — FPS, VPS, Speed, FrameTimes, ExtendedFPS, OSD, OSDDuration, OverlayStats, OverlayProjStats, Lag, FrameCount, ActiveTitle, NetPlayPing, RTC, InputDisplay, DebugUI, Cursor.
- 🎨 **Graphics Mods** — 67 pre-packaged mods (bloom/DOF/HUD removal) installable one by one, per game or globally.
- 🧾 **Session logs** — every launch produces a timestamped log with game ID, game name, and full emulator output.
- 📊 **Live reports** — current profile, applied level, toggle states, all readable from a single task.
- 🛠️ **Maintenance** — Restore Profiles, Uninstall Dolphin, View Logs.
- 🎬 **Overlay Menu** *(experimental)* — an in-game TUI for save/load state, reset, and exit. Callable with **MENU + START**. *(Hotkey handling on muOS is still a bit moody — expect this to mature).*

**Best for:** people who want to tinker, tune, and squeeze every frame.

📖 **[Read the full Bash Arsenal README →](02_RtCore_BashArsenal/)**

---

### 03 — Rt:Core 'Frontendone' 🚧

> **The full frontend. A console within a console.**

Everything from Editions 01 and 02, plus a proper frontend accessible from the muOS **Applications** menu. No more browsing folders for games. No more memorizing game IDs.

**Planned:**
- 🎮 **GameCube & Wii Library** — browse, filter, launch your collection.
- 🏠 **Homebrew Hub** — dedicated section for homebrew titles.
- 🎨 **Workshop** — create and manage custom profiles, toggles, per-game overrides.
- 📚 **Check & Guides** — compatibility database, setup guides, known-issue references.
- ⚙️ **Settings** — full emulator configuration from a graphical interface.

**Signature UI:** a **rotational flip transition** — press **SELECT** to switch between the **GameCube dashboard** and the **Wii dashboard**, with a complete visual restyle between the two. Same emulator. Two souls.

**Best for:** people who want the whole experience.

📖 **[Read the Frontendone roadmap →](03_RtCore_Frontendone/)**

---

## 🤝 Credits

Part of the **SPDW Factory** ecosystem, created by **Sir Pips**.

<div align="center">
  <img src="assets/spdwfactory_logo.png" width="250" alt="SPDW Factory Logo">
  <br><br>
  <img src="assets/spdw_symbol.png" width="60" alt="SPDW Symbol">
</div>

<br>

> ℹ️ **DISCLAIMER & COMMUNITY ACKNOWLEDGMENT**  
> This repository is **not** an original core built from scratch. Full credit for porting and pioneering GameCube/Wii emulation on muOS goes to the **original community developers**. This project is a **fine-tuning, optimization, and repository management effort** built on their foundation. We stand on the shoulders of giants. We just happen to be wearing roller skates.

### 🐬 Original Dolphin Core Developers

- **@Speedrun** ([Speedrun [+.[🐬].%]](https://community.muos.dev/u/speedrun)) — Original author of the Dolphin port for muOS (V9 / Take 3)
- **@FireBattleInMtl** ([@FireBattleInMtl](https://community.muos.dev/u/firebattleinmtl)) — Huge thanks for all changes after V8, fixing permissions, and creating the script to add Dolphin to muOS' `launch.sh`
- **@Snow** ([@Snow](https://community.muos.dev/u/snow)) (SnowV8) — For providing the newly compiled Dolphin binary file
- **@bitter_bizarro** ([@bitter_bizarro](https://community.muos.dev/u/bitter_bizarro)) — For adopting the core and making it compatible with muOS Goose!
- **@razorbeamz**, **@arkun**, **@SkiffguardLando**, **@chronoss0109**, **@Kirky**, **@Mikethe3ird**, **@Symphonial**, **@giodude**, **@lasagnesetting**, **@joshuarcastillo** — For testing, reporting issues, and improving the core

> *Check out the [Core History Archive](Core_History/) to browse legacy builds (V7, V8, V9) and read up on their evolution.*

### 🌐 Community

- [muOS Community Forum](https://community.muos.dev) — discussions, support, announcements
- [muOS Discord](https://discord.gg/muos) — real-time chat, testing, direct support
- [muOS Website](https://muos.dev) — official project page and docs

---

## 🔗 Links

- [GitHub Repository](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS)
- [Latest Release](https://github.com/SilverCrow2323/Dolphin-Core-for-MuOS/releases/latest)
- [Compatibility Database](https://silvercrow2323.github.io/Dolphin-Core-for-MuOS/)
- [muOS Documentation](https://muos.dev)
- [Dolphin Emulator](https://dolphin-emu.org)
- [GameTDB](https://gametdb.com) — cover art and game metadata

**Credits and licenses:**
- Original Dolphin core for muOS: @Speedrun
- Upstream: Dolphin Emulator, GameTDB, muOS, PortMaster
- License: GPL-3.0-or-later (see `LICENSE`)
- Third-party licenses: see `THIRD_PARTY_LICENSES.md`
- Notice: see `NOTICE`

*This project is not affiliated with Nintendo.*

<div align="center">

  <img src="assets/minoru_symbol.png" width="80" alt="Minoru Symbol">
  <br>
  *— Keep up the Sbrobbing. And forever Rintromping.*

</div>
