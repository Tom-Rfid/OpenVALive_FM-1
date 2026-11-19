# STATUS — OpenVALive FM-1

*Updated: 2026-11-17 — V0.3, the repository split*

What works on the FM-1, what is not verified yet, what was decided and what comes next. The synth's own status is
in [OpenVALive CORE](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/STATUS.md).

## In one line

V0.2 (four tracks, loops, CAPTURE, undo, scenes, Morph, effects, Creative Engine) is flashed and plays on the
owner's FM-1 (17 Nov). V0.3 adds the CONTROL MAP, SOUND EDIT, the modulation matrix and tempo-locked LFOs, and
splits OpenVALive into three repositories; it passes every test and the 80 simulator checks, **not yet flashed**.

## What works

- **A, the live line** and per-track gestures (18 Nov): simulator (96 checks); not yet on the FM-1.

- **Boot screen** (17 Nov): logo 5C on orange and the version (`V_0.0.03`), drawn by `va/app/src/splash.c` (~4 KB).

| Item | Verified |
|---|---|
| The app on fm1-base: four tracks, layers (ARP creative, GLO scenes, FX perform, SEQ tracks), knob pages SOUND / MACRO / LIVE / SETUP / USER, controller mode, live set saved in two flash objects, update from 0.1 keeps the sound | V0.2 on a real FM-1; fm1-base simulator (80 checks) |
| CONTROL MAP (GLO + SEL): the USER page's knobs to levels, macros, effects, sound knobs, tempo, MIDI CC | simulator |
| SOUND EDIT (ARP + SEL): every parameter, the modulation matrix, LFO sync / trigger | simulator |
| Time-stamped MIDI clock, MIDI IN channel / clock-only, program change → scene, key pressure, speaker low cut | V0.2 on the FM-1; tests |
| Firmware package, browser emulator, site with web installer and manual, releases | CI |
| `va/` submodule: OpenVALive CORE pinned, `scripts/va.sh` / `va.ps1` (init, status, tags, update, use, reset) | tested on Linux (va.sh) |

### Measured

- Real FM-1, V0.1: 4 % idle (6 % with chorus), ~5 % per voice, 26 % worst case (PAD, 4 notes). Flash 100 / 581 KB,
  RAM 36 / 96 KB, pool 100 / 336 KB.
- V0.3 package (CI, before the boot screen): 156 504 bytes.

## Not verified yet

- **V0.3 on the real FM-1**: CONTROL MAP, SOUND EDIT, the matrix's CPU cost with four busy tracks.
- **The Firmware Hub test**: install from V15, from another firmware, and leave again ([17](docs/_EN/17-publishing.md)).
- Windows scripts end to end on a clean PC (`va.ps1` not run yet); the web installer and emulator once Pages is on.

## Decisions

- Platform: **fm1-base + felucca-bsp** (MPL-2.0), not Felucca (GPL-3). Licence **MIT**.
- Three repositories (17 Nov 2026): OpenVALive_FM-1 (this one, the old OpenVALive renamed, history kept),
  OpenVALive_CORE (the synth, submodule `va/`), OpenVALive_SMK-37 (GPL-3.0).
- Branches: `dev` by default, `main` for releases only.
- Identity `FM-1_023` (the owner's, on The Firmware Hub, 17 Nov; V0.1–0.2 were `FM-1_77`). Fixed for every build
  (`fm1.toml` `id_fixed`, applied to fm1-base by `scripts/fm1-base-fixed-id.py`); the version is in the release. USB name kept as "OpenVALive FM-1" for the installers.
- The band at power-on: 1 INIT (4 voices), 2 BASS (1), 3 LEAD (2), 4 DRUMS 808.
- JieLi SDK from **Gitee**; Windows Python for flashing: **3.12**.

## Next steps, in order

1. Merge the split; set `dev` as the default branch; enable GitHub Pages (Settings > Pages > `gh-pages`).
2. Flash V0.3 and run [19 — FM-1 test plan](docs/_EN/19-fm1-test-plan.md).
3. Release: OpenVALive CORE first, pin its tag, then this repository's `v0.0.3` (the version restarts at 0.0.3 for the OpenVALive family, 17 Nov) (Actions > build > Run
   workflow on `main`); then the Firmware Hub.
