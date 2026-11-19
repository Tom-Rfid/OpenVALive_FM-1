# 11 — How the firmware is built (JieLi toolchain, fm1-base, packaging)

What happens between `core/*.c` and a `.fwsc` file the FM-1 accepts — so you can rebuild it, fix it, or port the
approach to another JieLi device.

## The chip and its tools

The FM-1 runs on a **JieLi AC791N / WL82** (CPU core `pi32v2`, 360 MHz, single-precision FPU, ~512 KB SRAM,
1 MB SPI NOR flash). JieLi provides:

| Tool | Where | Licence |
|---|---|---|
| **Toolchain**: clang 4.0.1 for pi32v2, linker, objdump | `https://pkgman.jieliapp.com/s/linux-toolchain` (Linux x86-64 only), fetched by `fm1-base/tools/get_toolchain.sh` into `~/.jieli/toolchain` | proprietary |
| **AC79 SDK** | `https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK` (the GitHub copy now asks for an account) | Apache-2.0 |

From the SDK only **three files** are used, to assemble the update package: `uboot.boot`, `cfg_tool.bin`,
`cfg/eq_cfg_hw.bin`, from the tag `AC79NN_SDK_V1.2.1_2023-12-13`. The build checks their SHA-256, so a mirror
with the same files works too. No JieLi library is linked into OpenVALive (it has no Bluetooth or WiFi).

## The software layers

```
targets/fm1 + va/ (OpenVALive)    app.h, app.c, ols_dsp.c → va/app, va/core   MIT
fm1-base                         platform: plat.h, device/*, host/*, tools  MPL-2.0
felucca-bsp (fm1-base submodule) chip/, boards/fm1/, loader/                MPL-2.0
JieLi                            toolchain + 3 SDK files                     downloaded
```

- **felucca-bsp** (Leo Kuroshita, Hügelton Instruments) is the hardware layer split out of Felucca: clocks,
  interrupts, flash, USB device (MIDI, serial, audio classes), the ST7789 screen, key scan, the audio DMA, the
  update loader and the update protocol.
- **fm1-base** (Charles Vestal) is everything above the hardware: drawing and fonts, panel, LEDs, audio callback,
  MIDI over USB and TRS, storage, the screen reader, the host simulator, the browser emulator, the build script,
  the package tools and the web installer site.
- The **app** provides `app_init`, `app_render`, `app_frame`, `app_panic`... (see `targets/fm1/app.h`).

## What `tools/build.py targets/fm1` does

1. Reads `targets/fm1/fm1.toml` (name, package identity `id_prefix`, USB names, `o2` units, options).
2. Generates headers: fonts from the TTF files (Pillow), the screen-reader words (`words.tsv`).
3. Builds the **update loader** (felucca-bsp `loader/`) as a RAM image → `build/loader/ota.bin`.
4. Compiles with `$JIELI_TOOLCHAIN/pi32v2/bin/clang -mcpu=r3 -mfprev1 -ffp-contract=off`:
   - `device/unity.c`: the whole platform **and** the app (`app.c` includes `src/*`) in one unit, at `-Os`;
   - each `o2` unit (`ols_dsp.c`, which includes `core/`) separately at `-O2`.
5. Links with the app linker script: app slot in flash, RAM code (`.ram_text`), `.data/.bss`, the `.pool`.
6. Runs **checks** on the image:
   - no soft-double routines (a `double` slipped in);
   - no 64-bit multiply inlined next to a 16-bit load (a known pi32v2 erratum, felucca-bsp `docs/CPU.md`);
   - no register access outside felucca-bsp;
   - sizes: image, RAM code, `.data+.bss`, pool against their limits.
7. Packs `build/openvalive.bin` + the loader + the 3 SDK files into **`openvalive.fwsc`** with felucca-bsp's
   `fm1pkg.py`, stamped with the identity (`FM-1_023` dev, `FM-1_023` release).
8. Writes `firmware.json` (for firmware hubs).

Output of our first real build:
```
ok    no soft-double routines (single-precision FPU only)
ok    image 102660 B; RAM code .ram_text 5100 B of 32768; RAM .data+.bss 36564 B of 98304; pool 102152 B of 344064
ok    register access: felucca-bsp only (device/, include/ and the app clean)
package  openvalive.fwsc  616003 B, identity FM-1_023
```

Other modes of the same script: `--host` (the simulator, with the PC's compiler), `--web` (the browser emulator,
emscripten), `--release X.Y` (release identity, refuses missing metadata), and `tools/make_site.py` (the site
with landing page, web installer, manual and emulator).

## What the core must respect to build there

The JieLi compiler is old (clang 4) and there is **no C library** beyond `memset`/`memcpy`/`memcmp`:

| Rule | Why | Checked by |
|---|---|---|
| no `<string.h>`, `<stdio.h>`, `<stdlib.h>`, `<stddef.h>` | headers don't exist | test "FM-1 without libc" |
| no `NULL` (write `0`), no `memmove` | not provided | same |
| `float` only, `f` suffix | soft-double is refused | `-Wdouble-promotion -Werror` + build check |
| `dsp_tanf` etc., not `tanf` | no libm: `OLS_FASTMATH` maps to fm1-base `fastmath.h` | test "fastmath = libm" |

Our first JieLi build failed exactly on `string.h` — the "without libc" test was added the same night so a PC
catches it from now on.

## How the firmware gets onto the FM-1

`fm1_install.py` (or the browser installer) speaks the update protocol over **USB-MIDI SysEx**:
1. the running firmware (any felucca-bsp-based one, or M-VAVE's) reads parts of the package and checks it;
2. it reboots into the update loader;
3. the loader reads the whole package and writes the flash — with the fast path, only the 4 KB sectors that
   differ (CRC table);
4. the FM-1 restarts, the installer checks the new identity: `done: the FM-1 runs FM-1_023`.

An interrupted install leaves the FM-1 in update mode: running the installer again finishes it.

## In CI

`.github/workflows/build.yml` does all of this on a clean Ubuntu runner: fetch fm1-base, the toolchain and the SDK,
run the tests, build the release firmware, the browser emulator and the site, cross-compile the desktop apps, and
publish (gh-pages, releases). A fork gets the same pipeline for free.
