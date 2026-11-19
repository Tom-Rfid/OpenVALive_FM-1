# CLAUDE.md — guide for agents (and busy humans)

OpenVALive FM-1: the live-first firmware for the M-VAVE FM-1. The synth, the Live Core and the app are
**OpenVALive CORE**, the git submodule `va/` (MIT): this repository only holds the FM-1 target, its site,
installers and prebuilt files. The SMK-37 is its own repository (OpenVALive_SMK-37, GPL-3.0).

## Commands

```bash
git clone --recursive https://github.com/Tom-Rfid/OpenVALive_FM-1      # or: sh scripts/va.sh init
FM1_BASE=~/fm1-base sh tests/run_tests.sh                            # VA tests + no-libc + simulator (80 checks)
python3 ~/fm1-base/tools/build.py targets/fm1 --host                 # the app in the PC simulator
python3 ~/fm1-base/tools/build.py targets/fm1                        # firmware (JieLi toolchain + AC79 SDK)
sh scripts/va.sh status | tags | update [BRANCH] | use REF | reset   # the va/ submodule (va.ps1 on Windows)
```

Before any commit: `tests/run_tests.sh` ends with "All tests pass.".

## Repository map

- `targets/fm1/` `app.h` (name, splash, `APP_STORE_MAP`, `APP_TOUCH`, `APP_OVERLOAD`, simulator checks), `app.c` and
  `ols_dsp.c` (one line each, including `va/app/`), `fm1.toml`, `site/`, `docs/MANUAL.md`, `docs/img/`, `tests/`.
- `va/` OpenVALive CORE at a pinned commit. **Never edit or commit inside it from here**: change it in its
  own repository, then move the pin (`sh scripts/va.sh update` or `use <tag>`, test, `git add va`, commit "va: …").
- `prebuilt/` FM-1 firmware + installer and the site, copied from a CI release (`scripts/update-prebuilt.sh`).
- `scripts/` `va.sh` / `va.ps1`, Windows (`install.ps1`, `flash.ps1`, `FLASH-FM1.bat`), WSL (`setup.sh`,
  `build-fm1.sh`), `make-composites.py`.
- `docs/_EN` and `docs/_FR`: the FM-1 docs; 03 explains how the synth is wired in.

## Branches

- **`dev`** is the default: `feat/…` / `fix/…` branches start from it and come back by PR.
- **`main`** only receives releases: PR `dev` → `main`, then Actions > build > Run workflow ("release" ticked).
- A release pins a **tag** of OpenVALive CORE.

## Rules

- The code rules (C99, float, no libc, no malloc, control rate, bit-identical refactors, new parameters at the
  end) are OpenVALive CORE's: its CLAUDE.md. They apply to `targets/fm1` too.
- `targets/fm1` only says how the FM-1 runs the app: device facts, nothing about the sound or the screens.
- Licence MIT; never GPL code (Felucca...). fm1-base and felucca-bsp are MPL-2.0.
- Docs: EN and FR together; only what is done or in progress (undecided ideas stay out of the repository);
  every "tested" says where. Update `STATUS.md` and `CHANGELOG.md` with the work.
- Rules for people, git and The Firmware Hub: `docs/_EN/18-rules-git-and-publishing.md`.

## Known pitfalls

- The JieLi SDK is cloned from **Gitee** (GitHub asks for an account).
- The JieLi compiler lives in `$JIELI_TOOLCHAIN/pi32v2/bin/`.
- Firmware file names are lower case: `openvalive.fwsc` (dev), `openvalive-X.Y.fwsc` (release).
- Flash from Windows with **Python 3.12** (not 3.14+): `py -3.12 fm1_install.py`.
- WSL cannot see USB-MIDI: flash from Windows or from the web installer.
- The Ubuntu emscripten package (3.1.6) is too old for fm1-base's web build; CI uses 3.1.74.
- `workflow_dispatch` only works once the workflow file is on `main`.
- `usb_product` stays "OpenVALive FM-1": the installers and DAWs find the running firmware by that name.
- A GitHub zip has an empty `va/`: `scripts/wsl/setup.sh` fetches it.
