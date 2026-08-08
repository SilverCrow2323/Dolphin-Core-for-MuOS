# 🏛️ Dolphin Core History & Archive

Welcome to the digital fossil record. This directory houses all previous iterations, test builds, and experimental packages of the Dolphin core for muOS, compiled *before* this repository officially existed to catalog the chaos.

These builds stem from the pioneering work and legendary experiments by **@Speedrun**, originally documented on the [MustardOS Community Forum (Topic #491)](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491).

---

## 📂 Available Historical Versions & Archives

Here is the complete inventory of the relics preserved in this archive, categorized by version:

### 🔹 Dolphin for muOS v7
* `Dolphin for muOS V7-hasjoys.zip` — Version tailored for dual-joystick handheld configurations.
* `Dolphin for muOS V7-nojoys.zip` — Version tailored for devices lacking physical joysticks.

### 🔹 Dolphin for muOS v8
* `Dolphin for muOS V8-hasjoy.zip` — Introduced single-joystick compatibility layouts.
* `Dolphin for muOS V8-hasjoys.zip` — Optimized dual-joystick build.
* `Dolphin for muOS V8-nojoys.zip` — Build optimized for joystick-free hardware.

### 🔹 Dolphin for muOS v9 (Take 1 to 3)
* `Dolphin for muOS V9-take1.muxupd` — Early V9 consolidation attempt.
* `Dolphin for muOS V9-take2.muxupd` — Iterative bugfix build.
* `Dolphin for muOS V9-take3.muxupd` — The milestone release by `@Speedrun` unifying builds into a single package.
* `Dolphin for muOS V9-Goose.muxupd` — Community-adapted update file restructured by `@bitter_bizarro` to ensure firmware compatibility with newer muOS versions (such as *Goose*).

### 🔹 Dolphin for muOS v10 [SPDW] (Custom Fork Iterations)
* `Dolphin for muOS v10_SPDW.muxupd` — Custom-branded evolution package carrying your own signature touch.
* `Dolphin_for_MuOS_v10.5.124_SPDW.muxupd` — Sub-version 10.5 build pushing experimental tweaks further down the rabbit hole.

---

## 📜 Technical Evolution & Changelog (Community Forum Data)

* **Initial Port & Concept:** Created by `@Speedrun` and introduced via `@Magnaderra` as a technical experiment to test if H700 hardware could somehow handle GameCube/Wii emulation.
* **Control Layout Adjustments (`gcpadnew.ini`):**
  * **V6:** For devices without joysticks, the D-Pad defaults to the Main Stick; `L2 + D-Pad` handles native D-Pad inputs.
  * **V8:** Added `L2 + A/B/X/Y` mapping to emulate the missing C-Stick on constrained hardware.
* **System Integration & Permissions:**
  * **@FireBattleInMtl & @Snow:** Fixed critical file permissions and engineered automated installation scripts to inject Dolphin directly into muOS's `launch.sh` starting from V5.
  * **@Snow:** Provided freshly compiled Dolphin binary files.
* **Safe Exit Protocol:** 
  * To exit the core safely without corrupting your system configuration, use the safe reset hotkey combo: press `L1 + L2 + R1 + R2` and hold the power button for **2 seconds**.

---

## 📚 Sources, References & External Archives

For full transparency and historical validation, all files, datasets, and binaries archived in this directory trace back to the following official and community resources:

* 💬 **Primary Discussion Thread:** [MustardOS Community Forum - Core Dolphin for muOS v9 (Take 3) by Speedrun](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491)
* 📊 **Original Compatibility Spreadsheet:** [Community Google Sheets Database](https://docs.google.com/spreadsheets/u/0/d/1LHXQV78yAuvii8J77KUgEt3Ap6TagjQzN48gdB9iVKY/htmlview)
* ☁️ **Community Cloud Mirrors & External Storage:**
  * Legacy mirror packages hosted across community-shared **Google Drive** and **MEGA** links distributed by contributors (`@Speedrun`, `@Snow`, `@bitter_bizarro`, and others) during the early, decentralized experimental phases of the core before this repository's establishment.