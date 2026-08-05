<div align="center">

# <img src="assets/spdw_symbol.png" width="27" alt="SPDW Symbol"> Dolphin Core for MuOS

**The definitive Dolphin optimization hub for muOS.**
*A handheld running an ARM SoC deserves to squeeze every drop of performance out of GameCube and Wii.*

[![muOS](https://img.shields.io/badge/muOS-Compatible-7B68EE?style=flat-square)](#)
[![Device](https://img.shields.io/badge/Device-RG35XX--H-FF6F00?style=flat-square)](#)
[![Emulation](https://img.shields.io/badge/Core-Dolphin-3776AB?style=flat-square&logo=nintendo-gamecube&logoColor=white)](#)
[![SPDW Factory](https://img.shields.io/badge/SPDW_Factory_Lab-00FFCC?style=for-the-badge)](#)
![Dolphin for muOS](assets/dolphinformuos.png)
</div>

## 📜 Overview

Stock firmware gives you basic emulation and stops there. Thanks to muOS, fortunately, countless doors of possibility are thrown wide open. It provides an effective and highly functional environment that significantly elevates the quality of these portable consoles—often of dubious (or entirely unknown) origins—pushing them to heights we thought impossible for a 200g pocket-sized contraption. Dolphin Core is one of those peaks.

The goal of **Dolphin Core for MuOS** — now included as part of the **[V0iD Project]** by SPDW Factory — starts from a different premise: running GameCube and Wii on an H700 chipset requires surgical precision, relentless testing, and custom optimization profiles. We are actively working on this core with the specific aim of pushing the hardware to its absolute limits (and maybe a little beyond) to offer a genuinely pleasant and playable experience for the GameCube catalog and, albeit much more difficult, the Wii library.

📊 **[Check the Community Compatibility List Here](https://docs.google.com/spreadsheets/u/0/d/1LHXQV78yAuvii8J77KUgEt3Ap6TagjQzN48gdB9iVKY/htmlview)**

---

## ⚙️ Key Features & Performance

### 🔧 General Optimizations
* **Strategic Underclocking:** Fine-tuning parameters like `Overclock = 0.4` to reduce virtual CPU load and prevent audio stuttering on the H700 chipset.
* **Adaptive Scaling:** Resolution adjustments and precise graphic flag management (`ImmediateXFBEnable`, `EFBToTextureEnable`) to maintain playable frame rates.
* **Visual Glitch Prevention:** Strict handling of `VISkip` to avoid breaking rendering engines on complex scenes.

### 📀 The Golden Tip: The Power of PAL ROMs
> If you are struggling to squeeze every single frame out of your handheld, **always look for PAL ROMs**. Running natively at **50fps** instead of 60fps (NTSC) drastically reduces the processing load on the core, often making the difference between an unplayable slideshow and a remarkably smooth experience.

---

## 🗺️ Future Roadmap & Under Development

* 🧩 **Game Profiles:** Dedicated, unique configuration pairs (`dolphin.ini` and `gfx.ini`) tailored for specific target games (like *Super Mario Strikers* and *Luigi's Mansion*) to solve severe bottlenecks on a title-by-title basis.
* 🎮 **Hotkey Mapping:** Advanced secondary control layers via `gptokeyb` utilizing an **M** modifier key for instant system shortcuts without external peripherals.

---

## 💾 Legacy Notes & Core Info

Before VoidDesk and SPDW Factory took over the optimization side, the foundation was laid by the original devs. Here are some critical legacy notes regarding the core itself you should be aware of:

* **Hardware Support:** RG28XX is **not** supported[cite: 1].
* **Exiting the Core:** To exit the core safely, use the Safe Reset Hotkey: press `L1 + L2 + R1 + R2` + hold the power button for 2 seconds[cite: 1]. *(Note: muOS standard hotkeys may also apply depending on your firmware version).*
* **Controller Logic (`gcpadnew.ini`):**
  * V6: For systems with no joysticks, the D-Pad defaults to the Main Stick[cite: 1].
  * V6: For systems with no joysticks, use `L2 + D-Pad direction` for standard D-Pad actions[cite: 1].
  * V8: `L2 + A/B/X/Y` mapped for C-Stick functionality[cite: 1].
* **Consolidated Build:** V9 consolidated the core into a single version for all devices, treating controller capabilities based on the device's built-in hardware (it will not account for a device with 0 or 1 joysticks connected to an external controller with 2 joysticks)[cite: 1].

---

## 🤝 Credits & Acknowledgments

Part of the **SPDW Factory** ecosystem, created by **Sir Pips**.

<div align="center">
  <img src="assets/spdwfactory_logo.png" width="250" alt="SPDW Factory Logo">
  <br>
  <img src="assets/spdw_symbol.png" width="60" alt="SPDW Symbol">
</div>

<br>

This project stands upon the shoulders of the talented developers and community pioneers who made GameCube emulation on H700 handhelds a reality — as initially explored and documented in the official [muOS Community Discussion for Dolphin V9](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491)[cite: 1]:
* **@Speedrun:** Original author of the Dolphin port for muOS (V9 / Take 3)[cite: 1].
* **@FireBattleInMtl:** Huge thanks for all changes after V8, fixing permissions, and creating the script to add Dolphin to muOS' `launch.sh`[cite: 1].
* **@Snow:** For providing the newly compiled Dolphin binary file[cite: 1].
* **@bitter_bizarro:** For adopting the core and making it compatible with muOS Goose![cite: 1]
* **muOS Development Team:** For ongoing firmware maintenance and structural support.

---

<div align="center">
  
  <img src="assets/minoru_symbol.png" width="80" alt="Minoru Symbol">
  <br>
  *continua a smontare le cose.*

</div>
