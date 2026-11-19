# 14 — The web simulator and the project site

## Try it in the browser

fm1-base compiles **the whole FM-1 app** — the same `app.c`, `src/` and `core/` — to WebAssembly, with a page that
draws the FM-1's screen, keys and knobs and plays the sound through Web Audio. Mouse, touch screen and computer
keyboard all work.

- Online: <https://tom-rfid.github.io/OpenVALive_FM-1/emu/>
- In the repository: `prebuilt/web/emu/` (serve it, see below)

## The site

CI builds a complete site with fm1-base's `tools/make_site.py`:

| Path | What |
|---|---|
| `/` | landing page (`targets/fm1/site/landing.md`) |
| `/emu/` | the browser emulator |
| `/install/` | the **web installer**: flashes the FM-1 from Chrome or Edge over Web MIDI, no Python needed |
| `/manual/` | the manual (`targets/fm1/docs/MANUAL.md` and its screenshots) |
| `/firmware/` | the `.fwsc` package |

It is pushed to the `gh-pages` branch on every push to `main` and on tags. **One-time setting** in the repository:
Settings → Pages → Build and deployment → Branch: `gh-pages` / root.

## Running it locally

WebAssembly pages must be served over HTTP (not opened as files):

```bash
cd prebuilt/web
python3 -m http.server 8000
# open http://localhost:8000/emu/   (and /install/ to flash from this page)
```

## Building it yourself

Needs emscripten (CI uses 3.1.74; the Ubuntu package 3.1.6 is too old for fm1-base):

```bash
python3 ~/fm1-base/tools/build.py targets/fm1 --web               # -> targets/fm1/build/emu/
python3 ~/fm1-base/tools/build.py targets/fm1 --release 0.1.0     # a release package for the installer
python3 ~/fm1-base/tools/make_site.py targets/fm1 targets/fm1/build/openvalive-0.2.0.fwsc 0.2.0 build/site
```

## Screenshots

The screenshots in the docs come from the fm1-base simulator, scripted by `targets/fm1/tests/screens.txt`:

```bash
targets/fm1/build/host/openvalive_host targets/fm1/tests/screens.txt targets/fm1/docs/img
```
Change the UI, run it again, and the manual's pictures follow. (The simulator shows CPU 0 %: only the device
measures it.)
