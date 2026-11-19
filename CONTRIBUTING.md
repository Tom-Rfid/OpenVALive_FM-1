# Contributing

Thank you! Issues and pull requests in English or French are welcome. The rules: [docs/_EN/18](docs/_EN/18-rules-git-and-publishing.md)
([français](docs/_FR/18-regles-git-et-publication.md)).

## Most useful right now

1. **Test on your FM-1** ([test plan](docs/_EN/19-fm1-test-plan.md)) and report: CPU on screen, clicks, pitch.
2. **Try the automatic Windows install** (`INSTALL-WINDOWS.bat`) on a clean PC.
3. **The web installer and the emulator** in your browser.

## Where does my change go?

| Change | Repository |
|---|---|
| the sound, an engine, the Live Core, the screens and pages | [OpenVALive_CORE](https://github.com/Tom-Rfid/OpenVALive_CORE) (then the `va/` pin moves here) |
| the FM-1's name, flash map, build settings, site, manual, installers | here |
| the SMK-37 | [OpenVALive_SMK-37](https://github.com/Tom-Rfid/OpenVALive_SMK-37) |

## Pull requests

- From a branch of `dev`, back to `dev`; one topic each.
- `FM1_BASE=~/fm1-base sh tests/run_tests.sh` must pass; CI runs it.
- Say **where** it is tested (simulator, real FM-1) and update `docs/_EN` and `docs/_FR` together (a short French
  note is fine — say so and someone will translate), plus `STATUS.md` and `CHANGELOG.md`.
- No code copied from a GPL source (Felucca...).
