<div align="center">

# **<img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinrt.png" alt="Dolphin Rt:Core" width="30"> Dolphin (pre)Rt:Core for muOS — History & Archive**

<br>

<img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinmuos_corehistory.png" alt="Core History" width="500">

<br><br>

Welcome to the digital fossil record. This directory houses all previous iterations, test builds, and experimental packages of the Dolphin core for muOS, compiled *before* this repository officially existed to catalog the chaos.

These builds stem from the pioneering work and legendary experiments by **@Speedrun**, originally documented on <br>
[MustardOS Community Forum (Topic #491)](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491).

</div>

---

## **📂 Historical Release Index & File Inventory**

| Version | File Name | Target Hardware / Description |
| :--- | :--- | :--- |
| **v7** | `Dolphin for muOS V7-hasjoys.zip` | Version tailored for dual-joystick handheld configurations. |
| **v7** | `Dolphin for muOS V7-nojoys.zip` | Version tailored for devices lacking physical joysticks. |
| **v8** | `Dolphin for muOS V8-hasjoy.zip` | Introduced single-joystick compatibility layouts. |
| **v8** | `Dolphin for muOS V8-hasjoys.zip` | Optimized dual-joystick build. |
| **v8** | `Dolphin for muOS V8-nojoys.zip` | Build optimized for joystick-free hardware. |
| **v9 (Take 1)** | `Dolphin for muOS V9-take1.muxupd` | Early V9 consolidation attempt. |
| **v9 (Take 2)** | `Dolphin for muOS V9-take2.muxupd` | Iterative bugfix build. |
| **v9 (Take 3)** | `Dolphin for muOS V9-take3.muxupd` | The milestone release by **@Speedrun** unifying builds into a single package. |
| **v9 (Goose)** | `Dolphin for muOS V9-Goose.muxupd` | Community-adapted update file restructured by **@bitter_bizarro** for **muOS Goose** firmware compatibility. |
| **v10 [SPDW]** | `Dolphin for muOS v10_SPDW.muxupd` | Initial custom fork release of the core. |
| **v10.5 [SPDW]** | `Dolphin_for_MuOS_v10.5.124_SPDW.muxupd` | Sub-version 10.5 build pushing experimental tweaks further. |

---

## **📜 Technical Evolution & Detailed Changelog**

### **📌 Key Contributors & Credits**

| Contributor | Role & Major Contributions |
| :--- | :--- |
| **@Speedrun** | Initial port creation, conceptual proof-of-concept, and author of the milestone V9 unified releases. |
| **@Magnaderra** | Co-pioneer in testing GameCube/Wii emulation feasibility on H700 hardware. |
| **@FireBattleInMtl** | Developed launch scripts for `launch.sh` integration and resolved critical file permissions. |
| **@Snow** | Maintained file permissions and provided fresh, performance-optimized Dolphin binary compilations. |
| **@bitter_bizarro** | Restructured V9 package layout for compatibility with newer **muOS Goose** firmware. |

---

### **🚀 Version History & Feature Milestones**

#### **🟢 Early Integration & Automated Scripts (V5 – V6)**
* **V5 Release:**
  * **System Launch Integration:** Included an automated script to inject Dolphin directly into muOS's `launch.sh` execution flow *(Thanks to @FireBattleInMtl)*.
  * **Permissions Fix:** Corrected binary file execution permissions across system packages *(Thanks to @FireBattleInMtl & @Snow)*.
* **V6 Release:**
  * **Control Remapping (`gcpadnew.ini`):** Enhanced control schemes for handheld devices without physical joysticks:
    * `D-Pad` defaults to functioning as the **Main Stick**.
    * `L2 + D-Pad Direction` triggers native D-Pad inputs.

#### **🟡 Hardware-Specific Era (V7 – V8)**
* **V7 Release:**
  * **Device-Specific Builds:** Separated core packages to match physical hardware layouts:
    * `hasjoys`: Dedicated build for dual-analog hardware.
    * `nojoys`: Dedicated build for devices without physical joysticks.
* **V8 Release:**
  * **Updated Dolphin Binary:** Recompiled core binary from source for improved performance and stability *(Thanks to @Snow)*.
  * **Single-Joystick Layout:** Introduced the `hasjoy` configuration package alongside `hasjoys` and `nojoys`.
  * **C-Stick Emulation (`gcpadnew.ini`):** Added `L2 + A / B / X / Y` mapping to simulate C-Stick inputs on constrained hardware.

#### **🔴 Unification & Modern Firmware Adapters (V9 – V10)**
* **V9 Milestone Releases (Take 1 – Take 3):**
  * **Universal Consolidation:** Merged `hasjoys`, `hasjoy`, and `nojoys` into a single, unified installation package.
  * *Note on External Controllers:* Default mapping prioritizes built-in device hardware; connecting a 2-joystick controller to a 0 or 1 joystick device uses internal hardware layout profile.
* **V9 Goose Update:**
  * Package structure revised and maintained by **@bitter_bizarro** for seamless operation on newer **muOS Goose** firmware versions.
* **V10 & V10.5 SPDW Custom Fork Iterations:**
  * `v10_SPDW`: Initial custom fork release of the core.
  * `v10.5.124_SPDW`: Advanced experimental sub-version pushing performance tweaks and internal core adjustments further.

---

## **🎮 Control Shortcuts & Hotkeys (`gcpadnew.ini`)**

| Action / Command | Button Combination | Hardware Scope / Notes |
| :--- | :--- | :--- |
| **Safe Core Exit** | `L1` + `L2` + `R1` + `R2` + **Hold Power (2s)** | Universal safe reset hotkey combo |
| **Main Stick Navigation** | `D-Pad` | Devices without joysticks (V6+) |
| **Native D-Pad Input** | `L2` + `D-Pad Direction` | Devices without joysticks (V6+) |
| **C-Stick Emulation** | `L2` + `A` / `B` / `X` / `Y` | Limited/Single joystick handhelds (V8+) |

---

## **📚 Sources, References & External Archives**

* 💬 **Primary Discussion Thread:** [MustardOS Community Forum - Core Dolphin for muOS v9 (Take 3) by Speedrun](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491)
* 📊 **Original Compatibility Spreadsheet:** [Community Google Sheets Database](https://docs.google.com/spreadsheets/u/0/d/1LHXQV78yAuvii8J77KUgEt3Ap6TagjQzN48gdB9iVKY/htmlview)
* ☁️ **Community Cloud Mirrors & External Storage:**
  * Legacy mirror packages hosted across community-shared [Google Drive](https://drive.google.com/drive/folders/1oIdjzDEuOw0CfErXUgp5cKmyypjnrjoJ?usp=sharing) and [MEGA](https://mega.nz/folder/OtViWDyR#9FMAES423bckWKd3Rwsjdw) links distributed by contributors (`@Speedrun`, `@Snow`, `@bitter_bizarro`, and others) during the early, decentralized experimental phases of the core before this repository's establishment.

