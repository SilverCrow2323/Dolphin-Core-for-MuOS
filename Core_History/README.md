<div align="center">

# <img src="https://imgs.search.brave.com/tyQv6MFjbbp1NULahYsqy1k4QZTSTi0ieuSbkCkdPS0/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi81LzUzL0Rv/bHBoaW5fRW11bGF0/b3JfTG9nb19SZWZy/ZXNoLnN2Zy8yNTBw/eC1Eb2xwaGluX0Vt/dWxhdG9yX0xvZ29f/UmVmcmVzaC5zdmcu/cG5nP3V0bV9zb3Vy/Y2U9d3d3Lndpa2lk/YXRhLm9yZyZhbXA7/dXRtX2NhbXBhaWdu/PWluZGV4JmFtcDt1/dG1fY29udGVudD10/aHVtYm5haWw" width="30" alt="SPDW Symbol"> Dolphin <i>(pre)</i>Rt:Core:// **🏛️ History & Archive** 
  <br>


<br>

<img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/dolphinmuos_corehistory.png" alt="Core History" width="520">

<br><br>

> ## 🏛️ *Welcome to the <u>**digital fossil record**</u>.*  
> This directory houses all previous iterations, test builds, and experimental packages of the <u>**Dolphin Core**</u> (**Nintendo GameCube** & **Nintendo Wii**) for **muOS**, compiled _before_ this repository officially existed to catalog the chaos.  
>  
> These builds stem from the **pioneering work** and **legendary experiments** by **@Speedrun**, originally documented on the  
> [**MustardOS Community Forum (Topic #491)**](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491).

</div>

---

## **📌 1. OVERVIEW & SYSTEM COMPATIBILITY**

This repository serves as a *technical* and *historical archive* for the Dolphin emulator port designed for <u>**muOS**</u> (operating on **Allwinner H700** handheld devices). It enables standalone emulation testing for both **Nintendo GameCube** and **Nintendo Wii** games.

* **🎯 Target Hardware:** Devices running **muOS** equipped with _0, 1, or 2 analog joysticks_ (e.g., **Anbernic RG35XX H**, **RG35XX SP**, **RG40XX H**, etc.).
* **⚠️ Incompatible Hardware:** <u>**Anbernic RG28XX is NOT supported**</u> due to display aspect ratio and physical hardware constraints.

---

## **💬 2. ORIGINAL COMMUNITY ANNOUNCEMENT & ARCHIVE RECORD**

Below is the preserved announcement from the **MustardOS Community Forum (Topic #491)**, capturing the exact post and context when the Dolphin core was first shared with the community.

<details>
<summary><b>🔍 Click here to expand Original Forum Post & Screenshot</b></summary>

<br>

<div align="center">
  <img src="https://raw.githubusercontent.com/SilverCrow2323/Dolphin-Core-for-MuOS/main/assets/muos_post.png" alt="Original Forum Post Screenshot" width="720">
</div>

<br>

> **Original Post Content by @Magnaderra (preserves @Speedrun's work):**
> 
> *"Hi everyone, this is a project to port the **Dolphin emulator**, the core for emulating the _Nintendo GameCube_ and _Nintendo Wii_.  
> Its author - dear **@Speedrun** [+.[].%] - has done his best and is leaving it to <u>posterity</u>.  
> 
> Screenshot 2025-06-05 at 01-11-40 • Discord #🎮｜general MustardOS  
> 
> You can download it here (Google Drive) and here (Mega)  
> Game compatability list is here  
> <u>**RG28XX is not supported**</u>  
> Huge thanks to **@FireBattleInMtl** for all changes after V8.  
> 
> **Changes in V5-V8:**  
> V@FireBattleInMtl Fixed permiss@FireBattleInMtlFi@SnowV8eBattleInMtlons thanks to @FireBattleInMtl@Snow  
> Updated dolphin binary  
> @SnowV8 Newly c@Snowmpiled binary file thanks to @Snow  
> **Changes to gcpadnew.ini for systems without joysticks and with only one joystick:**  
> V6 For no joysticks D-Pad defaults to the Main Stick.  
> V6 For no joysticks L2+D-Pad direction for D-pad.  
> V8 L2+A/B/X/Y for C-Stick.  
> **Future proofing the installation process:**  
> V5 The archive includes a script to add dolphin to muOS’ launch.sh thanks to @FireBattleInMtl  
> **Device-specific downloads:**  
> V8 Separate downloads are available for devices with (hasjoys), without (nojoys), and now introducing single joystick compatability! (hasjoy)  
> V9 consolidated it into a single version for all devices, but this will not account for a device which has 0 or 1 joysticks but connected to a controller which has 2 joysticks (it would be treated as what the device has built in).  
> **Exiting the core:**  
> To exit the core safely, use the Safe Reset Hotkey: press L1 + L2 + R1 + R2 + hold the power button for 2 seconds.  
> 
> I think it’s a really cool thing that it even exists. And I think people should know about it.  
> I’m not a developer and I don’t know how/won’t develop it. But you can if you wanna.  
> 
> **[UPD]** Now compatible with Goose! You can get adopted version here. Thanks to **@bitter_bizarro** !"*

</details>

---

## **📂 3. HISTORICAL RELEASE INDEX & FILE INVENTORY**

All archived releases preserved in this directory are cataloged below:

| Version | File Name | Format | Target Hardware & Notes |
| :--- | :--- | :--- | :--- |
| **v7** | `Dolphin for muOS V7-hasjoys.zip` | *Archive* | Tailored for <u>dual-joystick</u> handheld configurations. |
| **v7** | `Dolphin for muOS V7-nojoys.zip` | *Archive* | Tailored for devices <u>lacking physical joysticks</u>. |
| **v8** | `Dolphin for muOS V8-hasjoy.zip` | *Archive* | Introduced <u>single-joystick</u> compatibility layouts. |
| **v8** | `Dolphin for muOS V8-hasjoys.zip` | *Archive* | Optimized dual-joystick build with **recompiled binary**. |
| **v8** | `Dolphin for muOS V8-nojoys.zip` | *Archive* | Build optimized for <u>joystick-free hardware</u>. |
| **v9 (Take 1)** | `Dolphin for muOS V9-take1.muxupd` | **Package** | Early V9 _universal consolidation_ attempt. |
| **v9 (Take 2)** | `Dolphin for muOS V9-take2.muxupd` | **Package** | Iterative bugfix and _control layout update_. |
| **v9 (Take 3)** | `Dolphin for muOS V9-take3.muxupd` | **Package** | <u>**Milestone Release**</u> by **@Speedrun** unifying all hardware profiles. |
| **v9 (Goose)** | `Dolphin for muOS V9-Goose.muxupd` | **Package** | Restructured by **@bitter_bizarro** for <u>**muOS Goose**</u> firmware. |
| **v10 [SPDW]** | `Dolphin for muOS v10_SPDW.muxupd` | **Package** | First version of our _custom core fork_. |
| **v10.5 [SPDW]** | `Dolphin_for_MuOS_v10.5.124_SPDW.muxupd` | **Package** | Sub-version 10.5 pushing <u>experimental performance tweaks</u>. |

---

## **📜 4. TECHNICAL EVOLUTION & DETAILED CHANGELOG**

### **👥 Key Contributors & Credits**

| Contributor | Role & Contributions |
| :--- | :--- |
| **@Speedrun** | **Core Developer** & Author of the original port, key optimizations, and V9 <u>unified release</u>. |
| **@Magnaderra** | Documented and published the original core release on *MustardOS community forums*. |
| **@FireBattleInMtl** | Created `launch.sh` <u>auto-injection scripts</u> and fixed core file permissions post-V8. |
| **@Snow** | Provided **freshly compiled** Dolphin binaries from source and fixed permissions. |
| **@bitter_bizarro** | Adapted V9 package structures to ensure full compatibility with <u>**muOS Goose**</u> firmware. |
| **@SilverCrow2323** | Curator of the **SPDW custom core iterations** (V10 / V10.5) and repository archive maintainer. |

---

### **🚀 Version History & Technical Milestones**

#### **🟢 [V5 – V6] Early Experiments & System Integration**
* **V5 Release:**
  * **System Integration:** Included an automated script to inject Dolphin directly into muOS's `launch.sh` execution flow *(Thanks to **@FireBattleInMtl**)*.
  * **Permissions:** Fixed <u>binary file execution permissions</u> *(Thanks to **@FireBattleInMtl** & **@Snow**)*.
* **V6 Release:**
  * **Control Remapping (`gcpadnew.ini`):** Solved input layout for devices _without analog joysticks_:
    * `D-Pad` defaults to functioning as the <u>**Main Stick**</u>.
    * `L2 + D-Pad Direction` sends native _D-Pad directional inputs_.

#### **🟡 [V7 – V8] Hardware-Specific Era & C-Stick Emulation**
* **V7 Release:**
  * **Split Builds:** Divided core releases into separate `hasjoys` (*dual analog*) and `nojoys` (*zero analog*) packages.
* **V8 Release:**
  * **Recompiled Binary:** Recompiled Dolphin core binary from source for <u>enhanced CPU performance</u> *(Thanks to **@Snow**)*.
  * **Single-Joystick Support:** Introduced `hasjoy` configuration package alongside existing layouts.
  * **C-Stick Emulation (`gcpadnew.ini`):** Added `L2 + A / B / X / Y` mapping to simulate <u>**C-Stick inputs**</u> on hardware missing a second analog stick.

#### **🔴 [V9 – V10] Universal Unification, Firmware Adapters & Custom Forks**
* **V9 Milestone Releases (Take 1 – Take 3):**
  * **Universal Consolidation:** Merged `hasjoys`, `hasjoy`, and `nojoys` into a <u>single universal auto-detecting package</u>.
  * *External Pads Behavior:* Internal hardware layout takes precedence. Connecting a 2-joystick external gamepad to a 0 or 1 joystick device uses the _internal hardware profile_.
* **V9 Goose Adapter:**
  * Package structure adapted by **@bitter_bizarro** for seamless operation on <u>**muOS Goose**</u> firmware.
* **V10 & V10.5 SPDW Custom Fork Iterations:**
  * `v10_SPDW`: Initial _custom fork release_ of the core.
  * `v10.5.124_SPDW`: Advanced <u>experimental sub-version</u> pushing internal optimizations further.

---

## **🎮 5. CONTROL SHORTCUTS & HOTKEYS (gcpadnew.ini)**

| Action / Command | Button Combination | Scope & Notes |
| :--- | :--- | :--- |
| **Safe Core Exit** | `L1` + `L2` + `R1` + `R2` + **Hold Power (2s)** | <u>**Essential:**</u> This hotkey is NOT working. |
| **Main Stick Navigation** | `D-Pad` | Pre-configured for _zero-joystick devices_ (V6+). |
| **Native D-Pad Trigger** | `L2` + `D-Pad Direction` | Devices _without joysticks_ (V6+). |
| **C-Stick Emulation** | `L2` + `A` / `B` / `X` / `Y` | Limited or <u>single-joystick handhelds</u> (V8+). |

---

## **🔗 6. SOURCES, REFERENCES & COMMUNITY ARCHIVES**

* 💬 **Primary Discussion Thread:** [MustardOS Forum — Core Dolphin for muOS v9 (Take 3) by Speedrun](https://community.muos.dev/t/core-dolphin-for-muos-v9-take-3-by-speedrun/491)
* 📊 **Compatibility Spreadsheet:** [Community GameCube/Wii Compatibility Database](https://docs.google.com/spreadsheets/u/0/d/1LHXQV78yAuvii8J77KUgEt3Ap6TagjQzN48gdB9iVKY/htmlview)
* ☁️ **Community Cloud Mirrors:**
  * Legacy mirror packages hosted on [Google Drive Mirror](https://drive.google.com/drive/folders/1oIdjzDEuOw0CfErXUgp5cKmyypjnrjoJ?usp=sharing) and [MEGA Mirror](https://mega.nz/folder/OtViWDyR#9FMAES423bckWKd3Rwsjdw) distributed during early community testing.
