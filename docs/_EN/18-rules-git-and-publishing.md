# 18 — Rules: code, git and publishing

The rules everyone follows here, people and AI agents alike. They keep OpenVALive fast, readable and publishable.
The agents' version, with the commands, is [CLAUDE.md](../../CLAUDE.md).

## Branches

| Branch | What goes there |
|---|---|
| `dev` (default) | the work: every pull request targets `dev` |
| `feat/<topic>`, `fix/<topic>` | one topic each, from `dev`, back to `dev` by pull request |
| `main` | **releases only**: `dev` is merged into `main` by a pull request "Release vX.Y.Z", then published |

No direct push to `main`. An urgent fix on a release: `fix/<topic>` from `main`, PR to `main`, then merge `main`
back into `dev`.

## Commits and pull requests

- One topic per commit; a short English summary (imperative, ≤ 72 characters), then *why* in the body.
- Say **where** it is tested: PC, simulator, real device (model, firmware).
- `FM1_BASE=~/fm1-base sh tests/run_tests.sh` must end with "All tests pass." before a PR; CI runs it again.
- Work done with an AI agent says so: a `Co-Authored-By:` line in the commit.

## The `va/` submodule

- `va/` is [OpenVALive CORE](https://github.com/Tom-Rfid/OpenVALive_CORE) at **one pinned commit**. A clone needs `git clone --recursive`, or
  `sh scripts/va.sh init` afterwards.
- **Never commit inside `va/` from here.** A change to the synth, the Live Core or the app is made in OpenVALive
  VirtualAnalog (branch from its `dev`, PR, tests), then the pin moves here.
- Moving the pin is its own commit: `sh scripts/va.sh update` (latest `dev`) or `sh scripts/va.sh use v0.4.0`
  (a tag; also to go back), run the tests, then `git add va && git commit -m "va: v0.4.0"`.
- **A release pins a tag** of OpenVALive CORE, not a moving commit: release OpenVALive CORE first.
- `sh scripts/va.sh status` says if `va/` has moved or has local changes; `sh scripts/va.sh reset` undoes a move.
  Windows: `.\scripts\va.ps1` with the same commands.

## Code

- **C99, `float` only** (`f` suffix), no `double`: the JieLi compiler rejects it (`-Wdouble-promotion -Werror`).
- **No C library, no `malloc`** in the core and the app: `<stdint.h>` only; maths through `dsp_*`.
- Expensive maths (tan, exp, pow) only at **control rate** (every 32 samples) or when a parameter changes.
- The audio interrupt never blocks: no storage, no screen. The UI never touches an engine: it sends events.
- Engines sleep when silent and render any block size identically. **A refactor keeps the sound bit-identical.**
- New parameters go **at the end** (saved live sets store them by number).
- Small functions with one job, comments that say *why*, English in the code.
- Licence of this repository: **MIT**. Never copy code with a licence that does not allow it; MIT code from
  elsewhere keeps its notice.

## Docs

- **English and French together**: `docs/_EN` and `docs/_FR`, same numbers, same content.
- The repository describes what is **done or in progress**; undecided ideas stay outside it.
- Every "tested" says where and how. `STATUS.md` and `CHANGELOG.md` are updated with the work.

## Releasing

1. `dev` is green; `VERSION`, `CHANGELOG.md` and `STATUS.md` are up to date.
2. Pull request `dev` → `main` "Release vX.Y.Z", merged.
3. Actions > build > Run workflow, branch `main`, "release" ticked: the tag `vX.Y.Z` and the release are made.
4. Test the release on the real device (install, play, save, power cycle, leave again) and write it in `STATUS.md`.

## The Firmware Hub

[thefirmwarehub.com](https://thefirmwarehub.com) checks the repository and the release at once (source, licence,
`fmhub.json`, the package, its identity and flash chip), then Sven reviews every firmware himself.

| Rule | Here |
|---|---|
| An identity of our own, starting with `FM-1_`; the version may follow it | `FM-1_023` for every build and release (`fm1.toml` `id_prefix` + `id_fixed`, `scripts/fm1-base-fixed-id.py`); the version is in the release. **A fork changes it.** |
| A GitHub release with the `.fwsc` | `openvalive-fm1-X.Y.Z.fwsc`, from Actions > build > Run workflow on `main` |
| The way back in every package | fm1-base's update loader is in every package |
| Both flash chips (`0x856014`, `0xB36014`) | `firmware.json` lists both |
| `fmhub.json` at the root | `what`, `author`, `kinds`, `play` (emulator), `cheat` (manual), `image`, `color` |
| A `sounds` line if the firmware carries recordings | none: every sound is synthesised |
| Tested on a real FM-1, from M-VAVE's V15 **and** another firmware, and left again | written in `STATUS.md` with the date and the flash chip (`fm1_install.py --info`) |

The submission form, in short: what it is in one line; the features it uses; how it was tested (model, from which
firmware, and back); the sounds line; anything Sven should know (built on fm1-base + felucca-bsp, MIT, the
`va/` submodule).
