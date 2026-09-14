# Dolphin Rt:Core v11.0.0 - 'Bash Arsenal'

**SPDW Factory Lab / sirpips**

Tools, profile adjusters and graphic mods for Dolphin on muOS.

## Toggles - Display Overlays (GFX.ini)

| Toggle | Key | Section | Cost | Rec. |
|---|---|---|---|---|
| FPS | ShowFPS | Settings | minimal | ON |
| VPS | ShowVPS | Settings | minimal | OFF |
| Speed | ShowSpeed | Settings | minimal | ON |
| OverlayStats | OverlayStats | Settings | moderate | OFF |
| OverlayProjStats | OverlayProjStats | Settings | moderate | OFF |
| FrameTimes | LogRenderTimeToFile | Settings | moderate | OFF |
| FrameCount | ShowFrameCount | Settings | negligible | OFF |
| ExtendedFPS | ExtendedFPSInfo | Settings | negligible | OFF |

## Toggles - On-Screen Info (Dolphin.ini)

| Toggle | Key | Section | Values |
|---|---|---|---|
| OSD | OnScreenDisplayMessages | Interface | True/False |
| OSDDuration | OSDDuration | Interface | 1000/2500/5000 |
| ActiveTitle | ShowActiveTitle | Interface | True/False |
| Cursor | CursorVisibility | Interface | 1/0 |
| InputDisplay | ShowInputDisplay | Movie | True/False |
| RTC | ShowRTC | Interface | True/False |
| Lag | ShowLag | Interface | True/False |
| NetPlayPing | ShowNetPlayPing | Interface | True/False |

## Toggles - Debug

- **DebugUI** (`DebugModeEnabled`, `[Interface]`): significant cost.

Recommended: FPS or Speed ON, OSD ON, everything else OFF.

Toggles write to **all** of:
`Dolphin.ini`, `.compatibility`, `.performance`, `.rintromping`,
`GFX.ini`, `.compatibility`, `.performance`, `.rintromping`.

## Profiles

### Compatibility (accuracy first)

| Level | Overclock | SyncGPU | Res |
|---|---|---|---|
| MIN | 1.50 | ON | 3x |
| -2 | 1.40 | ON | 3x |
| -1 | 1.25 | ON | 2x |
| standard | 1.00 | ON | 1x |
| +1 | 0.90 | OFF | 1x |
| +2 | 0.80 | OFF | 1x |
| MAX | 0.70 | OFF | 1x |

### Rintromping (speed first)

| Level | Overclock | SyncGPU | Res |
|---|---|---|---|
| MIN | 1.10 | ON | 2x |
| -2 | 1.00 | ON | 1x |
| -1 | 0.90 | OFF | 1x |
| standard | 0.80 | OFF | 1x |
| +1 | 0.70 | OFF | 1x |
| +2 | 0.65 | OFF | 1x |
| MAX | 0.60 | OFF | 1x |

Side effects at high levels: missing tails/shadows/fog, audio crackle.

### Performance (daily driver)

| Level | Overclock | SyncGPU | Res |
|---|---|---|---|
| MIN | 1.30 | ON | 2x |
| -2 | 1.20 | ON | 2x |
| -1 | 1.10 | ON | 1x |
| standard | 1.00 | OFF | 1x |
| +1 | 0.90 | OFF | 1x |
| +2 | 0.80 | OFF | 1x |
| MAX | 0.70 | OFF | 1x |

### How To Choose

- Game crashes/glitches? -> Compatibility, go DOWN.
- Running full speed? -> Try Performance +1/+2.
- Too slow? -> Try Rintromping standard or higher.
- Artifacts? -> Move one step toward MIN.

**Rule:** start at STANDARD, move ONE step, test 5 min.
If unsure: Performance standard.

## Core Tools

- **Restore Profiles** - restore presets over Config/.
- **View Status** - show overview.log.
- **View Logs** - show latest session log.
- **Device Report** - full hardware/software dump.
- **Uninstall Dolphin** - ERADICATES everything. No undo.

## Graphic Mods

Workflow: Enable Mods -> Generate Installers -> Run installer -> List.

- Enable/Disable Mods: sets `EnableGraphicsMods` in GFX.ini.
- Generate Installers: one `.sh` per mod.
- List All Mods: `[X]` / `[ ]`.
- Clear All Mods: wipes Load/GraphicMods + installers.

## Key Paths
/opt/muos/share/emulator/dolphin/
/opt/muos/share/emulator/dolphin/Config/
/opt/muos/share/emulator/dolphin/rtdata/logs/
/opt/muos/share/emulator/dolphin/rtdata/graphic_mods/
/opt/muos/share/emulator/dolphin/Load/GraphicMods/
/opt/muos/share/task/Dolphin Rt:Core/
/opt/muos/share/emulator/gptokeyb/
/opt/muos/script/launch/ext-dolphin.sh

text

*Dolphin Rt:Core v11.0.0 - 'Bash Arsenal'*
