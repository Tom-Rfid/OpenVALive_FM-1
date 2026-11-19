# 15 — From zero to a flashed FM-1: how this project was bootstrapped

The story of the first night, step by step, with every wrong turn — so the next person (or the next fork) can
redo it in an hour instead of a night.

## 1. Write the DSP before touching the hardware

A portable C99 core first (`core/`): PolyBLEP oscillators, ZDF filter, envelopes, LFOs, delay, chorus, a 4-voice
VA engine, a MIDI parser — with a **PC simulator** that renders WAV files and measures CPU. Measured on a PC:
33 s of demo rendered 300 times faster than real time, no NaN, aliasing 15–20 dB better than naive oscillators.

## 2. Pick the right base: fm1-base, not Felucca

Reading Felucca (the best-known FM-1 firmware) showed it is **GPL-3.0**: copying from it would make the whole
project GPL. Its author split the hardware layer into **felucca-bsp** (MPL-2.0), and Charles Vestal built
**fm1-base** (MPL-2.0) on top: screen, keys, audio, MIDI, storage, simulator, emulator, build and install tools.
With them our code can stay MIT.

Hardware facts learned from their docs, all built into the code:
- audio is **44117.647 Hz** (24 MHz / 544), not 48 kHz, in **Q23 inside int32**, 256 frames per interrupt;
- CPU 360 MHz, single-precision FPU, **no libm** (use `fastmath.h`), doubles rejected;
- no MIDI OUT jack: MIDI out goes over USB;
- the SMK-37 is "planned, not started" in felucca-bsp.

## 3. Write the FM-1 app and run it in the simulator

`targets/fm1/`: keys with velocity, 4 knobs, presets, oscilloscope, CPU meter, save, MIDI in and out, the
event queue between UI and audio. The **fm1-base host simulator** ran the whole app with a script (13 checks,
screenshots, WAV) before any hardware was involved.

## 4. The build environment on Windows

| Step | What happened | Fix |
|---|---|---|
| WSL | `wsl --install`, then a reboot | as expected |
| fm1-base clone | worked | — |
| JieLi SDK clone | **asked for a GitHub username** | the GitHub repository is no longer public: use **Gitee**, tag `AC79NN_SDK_V1.2.1_2023-12-13` (another FM-1 firmware documented the same fix) |
| toolchain check | `ls ~/.jieli/toolchain/bin` failed | the compiler is in `pi32v2/bin/` — nothing was wrong |
| unzip | zip not in Downloads | find it, or `explorer.exe .` |
| host build | `No module named 'PIL'` | `sudo apt install python3-pil` |

## 5. The first real JieLi build

`fatal error: 'string.h' file not found`: the device has no C library. Removed `<string.h>`, `memset`,
`memmove`, `NULL` from the core, added the **"FM-1 without libc" test** so a PC catches it from now on.
Second build: success — 100 KB image, 36 KB RAM, no double, register access clean.

## 6. Flashing from Windows

| Step | What happened | Fix |
|---|---|---|
| commands | PowerShell commands typed into Ubuntu | Windows side = PowerShell |
| `pip install python-rtmidi` | needed a C++ compiler | Python 3.15 was too new: **`py install 3.12`** and `py -3.12 ...` |
| `fm1_install.py --info` | `MIDI inputs: (none)` | the FM-1 wasn't visible yet (cable / timing); second try: `FM-1_102 [running]` (another custom firmware was installed) |
| install | `done: the FM-1 runs FM-1_023` | — |

## 7. On the device

The screen came up as in the simulator, the sound came out, and the CPU meter said: **4 % idle, ~5 % per voice,
26 % worst case** (PAD, 4 notes, chorus + delay). Plenty of headroom.

## 8. Then: make it reusable

Everything that night became tooling: `INSTALL-WINDOWS.bat` (WSL → build → Python 3.12 → flash), `setup.sh`,
the tests, CI that builds the firmware, the browser emulator, the web installer site and the desktop apps, the
desktop app itself (no Linux needed to play), and these docs.

## Lessons

1. Simulate first: the FM-1 app worked on the first flash because it had run in the simulator.
2. Read the licence of every file before reading its code.
3. When `git` asks for a password on a public repository, the URL is wrong.
4. Pin Python to 3.12 on Windows for anything using `python-rtmidi`.
5. Turn every surprise into a test (`string.h` → the no-libc test) or a script step.
