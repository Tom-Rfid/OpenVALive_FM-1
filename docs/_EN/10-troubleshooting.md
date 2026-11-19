# 10 — Troubleshooting

Every error met while bringing the project up, and its fix.

## Setting up the environment

**`git clone` asks for `Username for 'https://github.com'`**
A public repository never asks for credentials: the address leads to no reachable repository. Press Ctrl+C, type
nothing. Known case: JieLi's SDK on GitHub (`Jieli-Tech/fw-AC79_AIoT_SDK`) now needs an account; use Gitee
(the scripts do):
```bash
git clone --depth 1 --branch AC79NN_SDK_V1.2.1_2023-12-13 \
    https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK.git ~/fw-AC79_AIoT_SDK
```
If you typed your GitHub password, it was rejected (GitHub refuses passwords on the command line); changing it
does no harm.

**`ls ~/.jieli/toolchain/bin`: No such file**
Normal: the compiler is in `~/.jieli/toolchain/pi32v2/bin/clang`. `JIELI_TOOLCHAIN` must point to
`~/.jieli/toolchain`.

**`ModuleNotFoundError: No module named 'PIL'`**
`sudo apt install -y python3-pil` (fm1-base renders the screen fonts).

**`unzip: cannot find or open …zip`**
The zip is not there. Find it: `find /mnt/c/Users/$USER* -iname 'openvalive*.zip' 2>/dev/null`, or open
Explorer from Ubuntu with `explorer.exe .` and drop the file in.

**PowerShell commands typed in Ubuntu** (`cd $HOME\Desktop` → `/home/userDesktop…`, `py: command not found`)
Windows commands go in **PowerShell** (`PS C:\…>`), Linux commands in **Ubuntu** (`user@PC:~$`).

## Building the firmware

**`fatal error: 'string.h' file not found`**
The FM-1 firmware is built without a standard C library. No `<string.h>`, no `memmove`, no `NULL` in `core/`
(see [07](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_EN/07-writing-an-engine.md)). The "FM-1 without libc" test catches this on a PC.

**`soft-double routines linked`**
A constant without `f` (`0.5` instead of `0.5f`) or a computation in `double`. The strict build of the tests
(`-Wdouble-promotion`) reports it.

**`cp: cannot stat '…/OPENVALIVE.fwsc'`**
The file is lower case: `openvalive.fwsc` (dev build) or `openvalive-X.Y.fwsc` (release build).

**`warning: fm1.toml has no install, screenshot`**
Only release builds need those fields; OpenVALive's `fm1.toml` has them.

## Installing on the FM-1

**`python-rtmidi`: `Unknown compiler(s)` / `metadata-generation-failed`**
Python too recent (3.14, 3.15): no prebuilt `python-rtmidi`. Use 3.12:
```powershell
py install 3.12
py -3.12 -m pip install mido python-rtmidi
py -3.12 fm1_install.py --info
```

**`error: FM-1 not found` / `MIDI inputs: (none)`**
Windows sees no MIDI device at all. In order: the FM-1 is on; a **data** cable (many USB-C cables only charge);
no hub; FL Studio and every MIDI program closed; it shows up in Device Manager. It can take a few seconds after
plugging in. WSL cannot see USB: install from Windows, or use the browser installer.

**The install was interrupted**
Run the same command again: `fm1_install.py` resumes an FM-1 left in update mode, and the loader only rewrites
the sectors that differ. Last resort: the Felucca web installer puts the official firmware back:
<https://hugelton.github.io/Felucca/>.

## On the device

**No sound**: turn MASTER up; check the headphones; look at `VOICES` (a key should make it 1/4).

**`CPU` above 90 %**: the app drops voices automatically (`VOICES x/3`, `x/2`...). Please report the preset and
the number of notes.

**Clicks when turning an encoder fast**: possible in V0.1 (parameters jump, no smoothing); the V0.2 parameter
system fixes this first.

## Desktop app

**"No audio output device could be opened"**: another program holds the device exclusively, or there is no
output; try `--rate 48000`.

**The MIDI keyboard does nothing**: `--list`, then `--midi N` (Windows) or `--midi /dev/snd/midiC1D0` (Linux,
your user must be in the `audio` group). Close DAWs that hold the port.

**Notes on the computer keyboard are short**: a terminal reports key presses, not releases. Hold the key (auto-repeat
keeps it sounding) or use a MIDI keyboard.
