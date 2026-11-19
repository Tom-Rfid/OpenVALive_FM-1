# Changelog






## 19 November 2026 — 12 new sounds, families by character

- Psytrance and transitions: TALK, PSY BASS, ZAP, LASER, BLIP, METAL, ARP, CHOIR, NOISE, RISER, DOWNLIFTER,
  SHAKER. Families: ACID, PSY, BASSES, DRUMS, PUNCH, SFX, DARK, SOFT, USER.

## 19 November 2026 — recording's pink from the first note

- The pink line starts at the first note recorded (or the punch), to see where the take began and when to stop.

## 19 November 2026 — lights checked, PAN

- Every layer's key lights checked; SAVE held lights the USER slots; the set-up screens light their buttons; SOUND
  EDIT and LOOP EDIT close with any menu button. MAP CONTROL target PAN: stereo on a knob.

## 19 November 2026 — new sounds, MAP CONTROL, OPTION CONTROL, EQ page

- THUNDER, RAIN, CREAK, STRINGS 70, VINTAGE KEYS; nine families (KEYS and SFX added, USER last).
- MAP CONTROL (GLO + SEL): the pages' order, hide a page, the knobs of MACRO, LIVE, EQ and USER; EDIT = default.
- OPTION CONTROL (HOME + key 16): PERC 1–4 (each D# / G# drum key its own sound, new bells and triangle), the page
  a new sound brings per track.
- EQ page: BASS, MID, TREBLE, MID FREQ on the whole mix.
- Playhead green on a red / pink line; a LOOP left on another track is let go by SEQ tapped. Tests: menus.txt,
  loopstop.txt.

## 19 November 2026 — A VOL, MUTE ALL moved

- SEL + first black key (F#3): MUTE ALL, blinking fast while all are out (white key 5 is free now).
- SEL + fourth black key (C#4): **A VOL**, the levels brought together over the longest loop, then it stops.
- SOUNDS: "3/5" under the family names. Test plan: tested on the latest FM-1 revision (no logo under the screen).

## 19 November 2026 — SOUNDS and SETTINGS tidied

- SOUNDS: place / family / ON-HIDDEN under the title, family names in colour, coloured help (SEL ON/OFF, OCT +/-,
  arrow down MENU: OUT). SETTINGS: DRUM KEYS drawn as the two keys (violet = in use; FX + key 15 / 16 still switch
  it live), KEYS ON SCREEN ON green / OFF red.

## 19 November 2026 — SOUNDS: one line a family

- SOUNDS stays open with HOME let go; one line a family (green all offered, blue “F2” some, red line none), a bottom
  MENU line to switch to SETTINGS (PRESET or OCT), any menu button closes and saves. SETTINGS has the MENU line too.

## 19 November 2026 — SOUNDS (favourites)

- HOME + key 14: **SOUNDS**, the sounds PRESET offers, family by family (green offered, red hidden; OCT− / OCT+ the
  whole family). PRESET and the family jumps skip what is hidden and the families left empty. The set-up keys blink
  slowly while HOME is held.
## 19 November 2026 — STAB, POLY, DRUM EQ

- Two sounds: **STAB** (house / techno chord stab, with the leads and keys) and **POLY** (warm Juno-style chords,
  with the pads). 31 sounds; the drum kits and USER sounds 2 higher (settings OLS9, older ones moved by themselves).
- **DRUM EQ** page (red), on a drum track only: BASS, TREBLE, the kick's and the hats' levels.
## 19 November 2026 — titles held, ARP %, recording shown, drums louder; recovery scripts

- A layer button held keeps its title; gestures show ↑ and the button; ARP shows the % a key gives, a tap chooses
  it, ARP let go takes it. Recording: a red infinity sign, the recorded line pink. MORPH unused: red. BARS on A fixed.
- Drums +30 %; clap, cowbell and triangle −20 %.
- `recovery/`: bring back a unit that no longer boots (JieLi USB key from a Raspberry Pi, then M-Flasher).
## 18 November 2026 — sound families

- F1–F7 before the sound's name; PRESET then OCT− / OCT+ jumps families.
## 18 November 2026 — 7 new sounds, LOOP EDIT (va: see VA)

- ACID SQUARE, ACID SCREAM, ACID DEEP, REESE, WOBBLE, DEEP SUB, DUB SIREN (doc 20 updated).
- LOOP EDIT: HOME + white key 15.
## 18 November 2026 — drum maps, settings rows (va: OpenVALive CORE a50da80)

Drum keys: ORIGINAL (toms high to low, D# / G# chosen) or GM map, FX + white key 15 / 16; keys send GM notes.
HOME + white key 16: the settings rows (DRUM KEYS, DRUM D#, DRUM G#, KEYS ON SCREEN). Doc 20 with both maps
(scripts/make-drum-keys.py), manual, docs 05. Simulator: 141 checks.

## 18 November 2026 — sounds in order, doc 20 (va: OpenVALive CORE e894943)

The synth sounds numbered in their played order (ACID 303 first); the scope's auto-gain shows every sound's shape.
New doc 20 (EN / FR): the sounds in order, their scope, the drum keys on a keyboard picture (General MIDI order).
targets/fm1/tests/sounds.txt makes the scope pictures. Simulator: 134 checks.

## 18 November 2026 — DRUMS 909, ACID 303 (va: OpenVALive CORE e9f8fc6)

DRUMS 909 after DRUMS 808; ACID named ACID 303; G# is a triangle; on a drum track kicks and open hat blink, snares and closed hat lit; PRESET in a played order, track 1 on ACID 303. Saved
sounds past DRUMS 808 move one up by themselves. Manual, docs 05, screenshots.

## 18 November 2026 — HOME and FX gestures, readable bars (va: OpenVALive CORE 092c24e)

HOME + key 1 / 2 / 3: PANIC / RESTART / STOP ALL; FX + key 1: the line's reset (both taken on release); bars white
on grey with bold black values; MACRO cyan; a gesture given up said on release (red, 1 s). Simulator: 134 checks.

## 18 November 2026 — recording a muted track, the bottom line (va: OpenVALive CORE e9919a0)

REC / PUNCH on a muted track replaces its loop and brings it back; bold yellow track number; gesture titles stay
while the button is held (given up: red); waiting sound dark orange, +SEL green; bottom line: page left, next page
right. Manual, screenshots.

## 18 November 2026 — SEL validates, PUNCH, GLO on release (va: OpenVALive CORE 4b9a224)

SEL holds the tracks layer, takes a waiting sound and points at a line (from A: swaps); FX turns the pages (the
app.h override is gone: fm1-base's names were right). EDIT held + keys: PUNCH. GLO + key taken on release. OCT
resizes a running loop. ENV / LFO lit when they can; values grey violet; SETUP pink, USER violet; no VOX.
Simulator: 132 checks. Manual, docs 05 and 19, screenshots.

## 18 November 2026 — look before you act (va: OpenVALive CORE b43e89d)

On a track, ARP / SEQ + key names the gesture, ARP / SEQ let go first applies it (mint), the key first gives it up;
SEQ tapped lets the loop go (on A: every loop); SEQ + OCT- / OCT+ resizes the loop. Simulator: 128 checks.

## 18 November 2026 — SEL and FX as printed, A swaps with a track, page colours (va: 881ddb8)

On the FM-1, fm1-base's B_FX is the printed SEL (seen on the device): `targets/fm1/app.h` sets BTN_TRACKS /
BTN_PAGES so the printed FX holds the tracks layer and the printed SEL the pages. From A, SEL held + SELECT, let
go: A and the track swap sounds and octaves (ENV / LFO on the track swap back / again). +SEL; page colours;
values centred, bold, split colour; a LOOP: red track and EDIT flickering; LEVEL 0–100; bars added repeat the loop; no KNOBS message on a page turn. Simulator: 123 checks.

## 18 November 2026 — FX tracks, SEQ perform, SEL pages; an octave per line (va: OpenVALive CORE 61a3ed5)

FX holds the tracks layer, SEQ the perform layer, SEL turns the pages; OCT- / OCT+ per line (T1..T4, A), kept
with USER sounds; no UNDO / REDO on A (live only); a running LOOP white on red and SEQ flickering; T1 everywhere;
VOX without the budget. Manual, docs 05, screenshots updated; simulator: 111 checks.

## 18 November 2026 — the live line (va: OpenVALive CORE dadae9a)

A, the live line under the four tracks (its own sound, live, with an arpeggiator); the gestures act on the selected
track, or on every track with A; per-track undo; loops let go on the grid; SEL = tracks layer (white key 5: MUTE
ALL 4), SEQ = pages; dim / lit lights; the value over its bar, selected track violet, A mint. Manual, docs 05 and
19, screenshots updated; simulator: 96 checks.

## 17 November 2026 — OpenVALive FM-1

OpenVALive becomes three repositories. This one (renamed OpenVALive_FM-1, history kept) keeps the FM-1 target,
its site, installers and prebuilt files. The synth, the Live Core and the app moved to OpenVALive_CORE, now
the `va/` submodule (`scripts/va.sh` / `va.ps1`: init, status, tags, update, use a tag, reset); the SMK-37 moved to
OpenVALive_SMK-37. New docs: 03 (how the synth is wired in) and 18 (rules: code, git, publishing). The desktop app
is released by OpenVALive_CORE. The entries below describe the whole project as it was.

## V0.4 (in progress) "Modulation"

Tested by 170 Live Core checks, the FM-1 simulator (80 checks) and the SMK-37 host test (47); the demo render is
bit-identical (a sound without modulation runs exactly the code it ran before).

### VA engine
- **Modulation matrix**, 4 slots per sound: source (LFO1, LFO2, filter env, amp env, velocity, pressure, key,
  random per note, motion) -> destination (pitch, osc 2, PW, cutoff, reso, level, osc mix, filter env amount, LFO
  rates, delay) x amount (-100..+100 %). Control rate: a few multiply-adds per voice every 32 samples.
- **LFOs locked to the tempo**: FREE or 4 bars .. 1/32 (dotted and triplets), on the bar (the Live Core gives
  every engine the tempo and the beat). **RETRIG** (the first key restarts the cycle) and **ONE** (one cycle, then
  hold: an extra envelope).
- 16 parameters at the end (61 in all): saved sets and 0.3 user sounds load; `OLS_MAX_PARAMS` 61.
- Engine API: optional `clock` (tempo + beats) and `motion` (a lane the Live Core will play).

### FM-1 and SMK-37
- **SOUND EDIT** page (ARP + SEL; SMK-37: SHIFT + SELECT too): every parameter of the track's sound, named
  choices for the VA (waveforms, modes, LFO lengths, the matrix's sources and destinations); the keys still play.

## V0.3 "SMK-37" — 2026-11-17

Built by CI for the SMK-37 Elite and Pro, tested on the host with a fake SDK (47 checks); not yet run on a real
SMK-37. The FM-1 firmware is the V0.2 one, rebuilt (identity `FM-1_77000300`).

### CONTROL MAP (FM-1 and SMK-37)
- A **USER** knob page and a **CONTROL MAP** menu (GLO + SEL; on the SMK-37, hold the Bluetooth button) to give
  each control a target: track level, macros, MORPH, SWING, PUMP, effects (FILTER, RESO, DRIVE, DELAY, CHORUS,
  CRUSH, DECAY on one track, the selected one or all), a sound knob, TEMPO, BEND, aftertouch, a MIDI CC (0–127).
- SMK-37: 10 slots: K1–K4, the 4 faders (a third FADER BANK, USER, LED blinking), the pitch and mod wheels.
- Kept in the flash (its own object: FM-1 0xD4000; SMK-37 in the sectors already reserved).

### SMK-37 Elite / Pro (`targets/smk37`, GPL-3.0)
- The FM-1 app on M-VAVE's `smk37_open` SDK (route C, approved by the owner): M-VAVE's scanner reads each key's and
  pad's factory calibration; their screen driver; our audio interrupt, pads and storage.
- **37 keys** with velocity; the white keys are the layers' 16 slots while GLO / ARP / SEQ / FX / SAVE is held.
- **16 RGB pads**: PERFORM (the 16 perform effects; **pressure sets how far** filter, delay, drive and crush go) or
  PLAY (PAD/STEP: notes, drums from C2; pressure = aftertouch). Colours show the layer and what runs.
- **4 faders**: track levels, or (FADER BANK) the macros ENERGY SPACE TENSION DENSITY.
- Pitch wheel ±2 semitones, **mod wheel = MORPH**, pedal = sustain, 8th encoder = MASTER, SHIFT + K1–K4 = LIVE page,
  SHIFT + ENV = REDO, Bluetooth button = TAP (Bluetooth off).
- **MIDI OUT jack**: clock, start/stop and notes, as over USB: a Roland T-8 follows.
- Linux build (`build.py`: the SDK's compile flags and linker script, a package writer ported from `Package.cs`),
  Windows flash script (`FLASH-SMK37.bat`), host test in `tests/run_tests.sh`, CI builds both models.

### FM-1
- The canvas is 240 × 80 (the tallest band drawn): 31 KB of RAM back.
- Release zip for Windows (`OpenVALive-FM1-X.Y.Z.zip`): browsers often refuse a bare `.bat`.
- Release button: Actions > build > Run workflow with "release" ticked.

### Docs
- New: 20 SMK-37 (controls, install, T-8 sync, test plan), EN + FR. 17: route C decided.

## V0.2 "Live Core" — 2026-11-17

Tested by 152 unit checks and the fm1-base simulator (75 checks); not yet flashed on a real FM-1.

### Live Core (`core/live`)
- Master clock: internal tempo, MIDI clock in (smooth between pulses) and out, start/stop, swing.
- Sample-accurate sequencing: the render is cut at every tick (96 PPQN).
- Four tracks, each with its own loop length (1 step to 8 bars), mute and level; chance and ratchet per note.
- REC (overdub, optional 1/16 quantize), **CAPTURE** (the last phrase becomes the loop, in time, even with the
  transport stopped), undo/redo (8 steps).
- 8 scenes, **Morph** between two scenes, hold overrides by role (filter, drive, delay), stutter 1/4..1/32.
- **Creative Engine**: Mutate, Humanize, Fill, Simplify, Rotate, Reverse, Transpose, Expand, Contract, Chance,
  Ratchet, Euclid.
- Live sets ("OLSP" v1, CRC-32): sounds, loops, scenes, tempo; sets from 0.1-sized engines load.

### Sound
- Parameter smoothing (5 ms) in the VA engine: no clicks from knobs, MIDI CCs or Morph.
- An engine with no voice and no tail sleeps: four idle tracks cost almost nothing.
- **Phaser** (4 stages, feedback) in the VA engine; 3 new parameters at the end (saved sets stay compatible).
- **17 VA presets**: INIT, BASS, PAD, LEAD, ACID, STRINGS, BRASS, PLUCK, ORGAN, SUB, SWEEP, WIND, HOLD, WHALE,
  SCREECH, GRUNGE, DRONE.
- **DRUM engine**, all synthesised (808 family): kick, snare, clap, closed/open hat with choke, 3 toms, rim, cowbell;
  kits 808, TIGHT, LOFI, IRON. GM notes and an every-octave layout for the keys.
- Engine API: roles and macros, so performance gestures and knobs work on every engine; a sound bank.

### FM-1
- New controls: SELECT track, ALGO tempo, PLAY, REC, EDIT = CAPTURE, ENV/LFO = undo/redo, SEL knob pages
  (SOUND / LIVE), layers on the white keys (ARP creative, GLO scenes, FX perform, SEQ tracks).
- **Controller mode** (local off): keys and knobs only send MIDI (channel = track, CC 74 71 75 94).
- Following another machine (Roland T-8, a DAW): MIDI in time-stamped where it lands (steady tempo), MIDI IN
  channel ALL / 1..16 / CLOCK only (hold SEQ, turn PRESET), program change n recalls scene n + 1.
- Expression: key pressure and MIDI channel pressure open the filter and deepen the vibrato; sent out as
  channel pressure.
- The built-in speaker gets a 130 Hz low cut (headphones keep the full sound).
- **User sounds**: SAVE + white key 1–8 keeps a track's sound as USER 1–8 (saved in flash, on any track).
- **Metronome** (SEQ + REC) with a one-bar **count-in** for REC from stop; **tap tempo** (SEQ + PLAY).
- **Safe start**: HOME held at power-on skips loading the saved set.
- **DJ-style performance**: perform effects latch on a tap and last while held; LOOP 1 bar..1/32, FILTER SHUT/OPEN,
  DELAY THROW, DRIVE, CRUSH, BREAK, SOLO, DRUMS ONLY, ALL OUT, ALL FX OFF; tracks taken out come back on the next
  bar; scenes recalled while playing land on the next bar, as a cut or a 1/2/4-bar cross-fade (auto-Morph).
- A SETUP knob page for preparation: MIDI IN, XFADE, QUANTIZE, BARS.
- **Instrument macros** (MACRO page): ENERGY, SPACE, TENSION, DENSITY move many parameters of every track at once
  (by role, on top of the stored sounds) and the density of the loops.
- **PUMP**: sidechain from the drum track to the others (LIVE page).
- **Scene chain** (song mode): GLO + PLAY plays the stored scenes in turn, 4/8/16 bars each.
- ACID gets **accents**: velocity opens the filter (new VA parameter VEL FILTER).
- Underground / grunge sounds, all synthesised: HOLD (ship's hold), WHALE, SCREECH, GRUNGE, DRONE, and the
  DRUMS IRON kit; a **bitcrusher** in the VA engine (bits and rate).
- Screen: track and sound, tempo and transport, the four loops with playheads, knob pages.
- SAVE keeps the whole live set (two new flash objects); updating from 0.1 keeps the 0.1 sound on track 1.
- Firmware identity is now **FM-1_77** (FM-1_42 is MODELAR's); `fmhub.json` for The Firmware Hub.

### Computer
- The desktop app runs the Live Core: four tracks, drums, every gesture on the keyboard, `openvalive.set` files,
  a 4-track `--demo`.

### Docs
- New: 16 the Live Core, 17 publishing (Firmware Hub, releases, SMK-37), 18 future modes and forks (EN + FR).
- Manual, using the FM-1, desktop app rewritten for V0.2; new screenshots.


## V0.1 "Foundations" — 2026-11-17

First version, validated on a real FM-1.

### DSP core
- PolyBLEP oscillators (saw, PWM square, triangle), sub, noise.
- Trapezoidal ZDF state variable filter (LP, BP, HP, Notch).
- Exponential ADSR envelopes, 4-shape LFOs, rational tanh saturation.
- int16 delay with filtered feedback, Juno-style stereo chorus (I, II, I+II).
- Fixed (compile-time) or run-time sample rate.
- libm (PC) or fastmath (FM-1), builds without a C library.

### VA engine
- 4 voices, poly or mono legato with glide, voice stealing, load shedding.
- 40 normalised parameters, 4 presets (INIT, BASS, PAD, LEAD).
- Split into small files (api, params, presets, voices, render); audio bit-identical to the first version.

### Live core
- MIDI parser (running status, USB-MIDI), CC mapping.
- Timestamped SPSC event queue.

### FM-1
- App on fm1-base: velocity keys, encoders, presets, octave, oscilloscope (~11 ms window), CPU load, save,
  MIDI in USB/TRS, MIDI out USB, voice shedding. Code split into `src/`.
- Measured on the device: 4 % idle, ~5 % per voice, 26 % worst case.
- Manual and landing page for the fm1-base site; screenshots generated by a simulator script.

### Computer
- Desktop app for Windows / Linux / macOS (miniaudio; WinMM and ALSA MIDI; computer keyboard; offline render).
- C API with a tested example; PC simulator (demo, sweep, benchmark).
- Daisy Seed and Teensy templates (untested).

### Tooling
- 11 automatic tests; CI building the release firmware, browser emulator, web-installer site, desktop apps and
  releases (nightly, preview, tags).
- Automatic Windows install (WSL, build, Python 3.12, flash), WSL scripts, `scripts/update-prebuilt.sh`.
- `prebuilt/` with the firmware, installer, desktop apps and site.
- Documentation: 16 documents in English (`docs/_EN`) and French (`docs/_FR`).
