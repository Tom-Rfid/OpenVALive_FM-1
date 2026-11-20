# 04 — Install

Every route ends with the same file, `openvalive-fm1-X.Y.fwsc`, installed on the FM-1.

> **Before any flash:** back up your presets and projects. To go back to M-VAVE's official firmware (V15 or V16),
> the Felucca web installer offers it: <https://hugelton.github.io/Felucca/> (Chrome or Edge). On recent FM-1
> units with UC25HQ80 flash, read Felucca 1.8.2's release notes first.

## A. From the browser (easiest, no tools)

Open the project site's **installer**, <https://tom-rfid.github.io/OpenVALive_FM-1/install/>, in Chrome or Edge,
connect the FM-1 by USB, follow the page. It uses Web MIDI and the same update protocol as the command-line
installer. The site also has the **browser emulator** to try first.

*(The site is published by CI once Pages is enabled on the repository: Settings → Pages → Branch `gh-pages`.)*

## B. The prebuilt firmware

**Windows, the easiest**: from the latest [release](https://github.com/Tom-Rfid/OpenVALive_FM-1/releases), download
**`OpenVALive-FM1-X.Y.zip`**, unzip it, plug the FM-1 in, double-click **`FLASH-FM1.bat`** (or right-click
`flash.ps1` → *Run with PowerShell*). The script prepares Python 3.12 the first time.

Otherwise: the latest release's assets (`OpenVALive-FM1-X.Y.Z.zip`). Install it with the browser
installer, or from a command line (Windows, Linux, macOS):

```bash
pip install mido python-rtmidi          # Windows: py -3.12 -m pip install mido python-rtmidi
python3 fm1_install.py --info           # changes nothing: says what the FM-1 runs
python3 fm1_install.py openvalive-fm1-0.2.0.fwsc
```
`fm1_install.py` and `fm1ports.py` are next to the firmware in the release zip (they come from fm1-base).

## C. Windows, build it yourself, automatically

1. Download the project (GitHub's green **Code → Download ZIP**) and unzip it.
2. Double-click **`INSTALL-WINDOWS.bat`**.
3. Follow it. The script:
   - installs **WSL and Ubuntu 24.04** if needed. The first time: **restart**, open *Ubuntu* from the Start menu
     to create your Linux user, then **run** `INSTALL-WINDOWS.bat` **again**;
   - inside Ubuntu (asks for your Ubuntu password once, for `sudo`): installs the packages, **fm1-base**, the
     **JieLi toolchain**, the **JieLi SDK** (from Gitee), runs the **tests**, builds the **firmware**;
   - copies the result to `Desktop\OpenVALive-FM1`;
   - installs **Python 3.12** and `mido` + `python-rtmidi` on Windows;
   - offers to **install the firmware** on the plugged-in FM-1.

Run on its own (without the rest of the project), the script **asks for the zip's path**, or downloads the
project from GitHub if you leave it empty. Later, to reinstall: double-click
`Desktop\OpenVALive-FM1\FLASH-FM1.bat`.

```powershell
powershell -ExecutionPolicy Bypass -File scripts\windows\install.ps1 -Zip C:\path\OpenVALive.zip
powershell -ExecutionPolicy Bypass -File scripts\windows\install.ps1 -NoFlash
```

## D. Linux (or an existing WSL), one script

```bash
git clone --recursive https://github.com/Tom-Rfid/OpenVALive_FM-1
bash OpenVALive_FM-1/scripts/wsl/setup.sh                 # everything: tools, tests, firmware
bash OpenVALive_FM-1/scripts/wsl/setup.sh --host-only     # simulator + tests only
bash ~/OpenVALive/scripts/wsl/build-fm1.sh --out /mnt/c/Users/ME/Desktop/OpenVALive-FM1   # rebuild
```

On native Linux the FM-1 is visible directly: `pip install mido python-rtmidi`, then
`python3 ~/fm1-base/tools/fm1_install.py targets/fm1/build/openvalive.fwsc`. The JieLi toolchain only exists for
Linux x86-64; on macOS, fm1-base can run it in a Docker container (see its docs; not tested here).

## E. By hand, step by step

What the scripts do — to understand or to fix. The full story, with every pitfall we met, is in
[15 — From zero to a flashed FM-1](15-from-zero-to-fm1.md); how the build itself works is in
[11 — How the firmware is built](11-how-the-firmware-is-built.md).

1. **WSL** (PowerShell as administrator): `wsl --install -d Ubuntu-24.04`, restart, open Ubuntu, create the user.
2. **Packages** (Ubuntu):
   ```bash
   sudo apt update
   sudo apt install -y git build-essential python3 python3-pil python3-numpy curl xz-utils unzip rsync
   ```
3. **fm1-base, toolchain, SDK**:
   ```bash
   cd ~
   git clone --recursive https://github.com/charlesvestal/fm1-base
   bash fm1-base/tools/get_toolchain.sh
   git clone --depth 1 --branch AC79NN_SDK_V1.2.1_2023-12-13 \
       https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK.git ~/fw-AC79_AIoT_SDK
   echo 'export JIELI_TOOLCHAIN=$HOME/.jieli/toolchain' >> ~/.bashrc
   echo 'export AC79_SDK=$HOME/fw-AC79_AIoT_SDK' >> ~/.bashrc
   source ~/.bashrc
   ```
4. **Build**:
   ```bash
   git clone --recursive https://github.com/Tom-Rfid/OpenVALive_FM-1 ~/OpenVALive && cd ~/OpenVALive
   FM1_BASE=~/fm1-base sh tests/run_tests.sh
   python3 ~/fm1-base/tools/build.py targets/fm1          # -> targets/fm1/build/openvalive.fwsc
   ```
5. **Flash** (PowerShell on Windows: WSL can't see USB-MIDI):
   ```powershell
   py install 3.12
   py -3.12 -m pip install mido python-rtmidi
   cd $HOME\Desktop\OpenVALive-FM1
   py -3.12 fm1_install.py --info
   py -3.12 fm1_install.py openvalive.fwsc
   ```

A successful install ends with `done: the FM-1 runs FM-1_023...`. An interrupted install resumes when you run the
same command again.

## After installing

- The screen shows `OPENVALIVE INIT`, the oscilloscope and four bars.
- Sound comes out (turn MASTER up); key 4 at octave 0 plays an A at 220 Hz.
- Top right, `CPU`: ~4 % idle, ~24 % with 4 notes.

Problems? [10 — Troubleshooting](10-troubleshooting.md).
