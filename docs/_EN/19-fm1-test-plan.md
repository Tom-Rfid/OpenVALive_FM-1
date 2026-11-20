# 19 — FM-1 test plan (V0.2)

The same checklist as [the French one](../_FR/19-plan-de-test-fm1.md), in short. Write OK or what you saw.

Tested so far on the latest FM-1 hardware revision (no M-VAVE logo under the screen; November 2026). An older
revision (logo under the screen) is welcome as a tester.

| Section | Checks |
|---|---|
| 0 Install | `fm1_install.py --info` (note the flash part), install `openvalive-0.0.3.fwsc` → `FM-1_023`, the screen shows T1 INIT 120 BPM STOP |
| 1 Sound, CPU | idle CPU ≤ 5 %; every sound on PRESET (17 synths, 4 kits) clean and balanced; drums on C D F# A#; speaker vs headphones; key pressure opens the filter |
| 2 Loops | CAPTURE while playing loops in time (at STOP: PLAY FIRST); undo/redo; metronome; tap tempo; MUTATE by velocity; Euclid on drums; CPU with 4 busy tracks (< 80 % expected) |
| 3 Performance | SEQ tap = latched loop; BREAK held then released drops on the one; two effects together, key 16 all off; scene on the next bar; 2-bar cross-fade; MORPH knob |
| 4 Memory | SAVE + key = USER sound (LOAD 1–8, SAVE 9–16); SAVE + 6th black key (F#4) = SAVE ALL, power cycle, everything back; HOME at power-on = safe start |
| 5 MIDI | notes in play the selected track; CONTROLLER mode in a DAW; Roland T-8 as master (CLOCK only, CLOCK IN); CLOCK OUT to a DAW |
| 6 Leaving | install another firmware and back; back to M-VAVE V15 |
