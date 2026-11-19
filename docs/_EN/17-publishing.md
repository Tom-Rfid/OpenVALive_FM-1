# 17 — Publishing: releases and The Firmware Hub

## Releases

The CI does the work (`.github/workflows/build.yml`):

| You push | You get |
|---|---|
| a branch with a PR | a `preview-<branch>` prerelease: `.fwsc`, desktop apps, site |
| `main` | the `nightly` prerelease and the website (gh-pages) |
| a tag `vX.Y.Z` | a **release** with `openvalive-X.Y.Z.fwsc`, `firmware.json`, the installers and the desktop apps |

To release: merge to `main`, update `VERSION` and `CHANGELOG.md`, then `git tag v0.2.0 && git push --tags`.
`scripts/update-prebuilt.sh v0.2.0` then copies the release files into `prebuilt/`.

## The Firmware Hub (thefirmwarehub.com)

The hub lists FM-1 firmwares from their GitHub releases. Its requirements, and where OpenVALive FM-1 stands:

| Requirement | Status |
|---|---|
| Open source, complete source public | ✅ MIT, everything in the repository |
| A GitHub release with the `.fwsc` attached | ⏳ after merging to `main` and tagging (the hub picks it up within 3 h) |
| Its own identity (`FM-1_` + digits) | ✅ `FM-1_023`, fixed: the version is in the release (V0.1–0.2 were `FM-1_77`) |
| The update loader in the package, so players can leave again | ✅ fm1-base's loader is in every package |
| Tested on a real FM-1: installed from V15 **and** from another firmware, and left again | ⏳ to do on V0.2 (see below) |
| `fmhub.json` at the repository root | ✅ `fmhub.json` (kinds `groove`, play = the emulator, image = `docs/img/fm1-card.png`) |
| A `sounds` line if the firmware carries recordings | not needed: every sound is synthesised |
| Accept both flash parts (`0x856014` and the newer `0xB36014`) | ✅ fm1-base's `firmware.json` lists both |

### The hardware test the hub asks for

1. From M-VAVE's **V15**: install OpenVALive FM-1 (web installer or `py -3.12 fm1_install.py openvalive-0.2.0.fwsc`),
   play, SAVE, power off and on: the set comes back.
2. From **another firmware** (Felucca, SLOOP, X0X...): install OpenVALive FM-1 the same way.
3. **Leave** again: the installer page's "back to V15" (or `fm1_install.py` with M-VAVE's package) must work from
   OpenVALive FM-1.

Write down the date, the FM-1's flash part (`fm1_install.py --info`) and what you did in `STATUS.md`. That note is
what the hub asks for.

## The SMK-37

The SMK-37 Elite / Pro firmware has its own repository, [OpenVALive_SMK-37](https://github.com/Tom-Rfid/OpenVALive_SMK-37)
(GPL-3.0, on M-VAVE's `smk37_open`), with its own identity, releases and Firmware Hub page.
