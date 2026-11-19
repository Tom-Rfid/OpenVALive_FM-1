# 03 — The synth inside: OpenVALive CORE, and how it is wired

This repository holds the **FM-1 half** of OpenVALive. The synth, the Live Core and the app's screens are
[OpenVALive CORE](https://github.com/Tom-Rfid/OpenVALive_CORE) (MIT), included here as a git submodule in `va/`. This page is the short version;
the full one is in that repository ([architecture](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_EN/03-architecture.md)).

## The layers

```
 FM-1 hardware      keys, 14 buttons, 7 encoders, screen 240x240, codec, USB-MIDI, DIN MIDI, flash
      │
 fm1-base           the platform (MPL-2.0): boot, drivers, plat.h API, audio interrupt, store, simulator, web build
      │                                                                      ── this repository: targets/fm1/
 targets/fm1        app.h (name, flash map, switches) · app.c → va/app/openvalive_app.c · ols_dsp.c → va/app/ols_dsp.c
      │                                                                      ── the submodule: va/
 va/app             the instrument: pages, layers, CONTROL MAP, SOUND EDIT, saving, MIDI   (unity build, -Os)
 va/core/live       the Live Core: clock, 4 tracks, REC, CAPTURE, undo, scenes, Morph, Creative Engine
 va/core/engines    VA (2 osc + sub + noise, filter, 2 env, 2 LFO, mod matrix, FX) · DRUM (808 family)
 va/core/dsp        PolyBLEP, ZDF SVF, ADSR, LFO, delay, chorus, phaser    (ols_dsp.c, -O2, fastmath)
```

## One note, from the key to the speaker

| Step | Where | When |
|---|---|---|
| 1. A key goes down: fm1-base reads it, with its velocity (`APP_TOUCH`) | fm1-base `lib/touch.h` | main loop |
| 2. The app turns it into a note on the selected track, or a layer gesture (scene, effect, creative...) | `va/app/src/ui_input.c` | main loop, ~60 Hz |
| 3. It pushes an `ols_event_t` into the lock-free queue (the UI never touches an engine) | `va/app/src/app_events.c` | main loop |
| 4. The audio interrupt reads the queue and the incoming MIDI, then renders 256 frames | `va/app/src/app_audio.c` | every 5.8 ms |
| 5. The Live Core plays the loops to the sample, records, sends notes to the 4 engines | `va/core/live/live.c` | inside the render |
| 6. Each engine renders; modulation and expensive maths run every 32 samples (control rate) | `va/core/engines/va/` | inside the render |
| 7. The mix goes out as int32 Q23 stereo at 44117.647 Hz (24 MHz / 544) | fm1-base audio | inside the render |

## What the FM-1 adds

| What | Where |
|---|---|
| Name `OPENVALIVE`, splash colour, identity `FM-1_023` | `targets/fm1/app.h`, `fm1.toml` |
| Flash map: settings 0xFC000, calibration 0xDC000, live set 0xD8000 + 0xDA000, user sounds 0xD6000, CONTROL MAP 0xD4000 | `APP_STORE_MAP` in `app.h` |
| Key velocity and pressure, voice shedding on overload | `APP_TOUCH`, `APP_OVERLOAD` |
| MIDI time-stamping, headphone low cut, no Bluetooth | `fm1.toml` |
| Site, manual, screenshots, simulator scripts (80 checks) | `targets/fm1/site`, `docs/`, `tests/` |

## Changing the synth

A change to the sound, the Live Core or the screens is made **in OpenVALive CORE**, tested there, then this
repository moves its pin:

```bash
sh scripts/va.sh status            # which version is pinned
sh scripts/va.sh update            # va/ to the latest dev    (or: use v0.4.0 · use <commit> to go back)
FM1_BASE=~/fm1-base sh tests/run_tests.sh
git add va && git commit -m "va: v0.4.0"
```

Windows: `.\scripts\va.ps1 status | update | use v0.4.0 | reset`. Details: [18 — rules](18-rules-git-and-publishing.md).

| To learn | Read (OpenVALive CORE) |
|---|---|
| the Live Core (loops, CAPTURE, scenes, Morph) | [16](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_EN/16-the-live-core.md) |
| writing an engine | [07](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_EN/07-writing-an-engine.md) |
| the app's platform contract | [app/README.md](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/app/README.md) |
| tests and measurements | [08](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_EN/08-tests-and-measurements.md) |
