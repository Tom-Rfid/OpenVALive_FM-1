# OpenVALive

<img src="img/openvalive-logo.png" alt="OpenVALive" width="160" height="160">

**A live-first instrument for the M-VAVE FM-1.** It has four synth tracks, each with its own loop. Play freely and
press CAPTURE: what you played loops, in time. Undo anything. Glide between scenes with one knob. Hold a key to
stutter or sweep. Let the Creative Engine mutate, humanize, fill or simplify your loops. No menus. Open source,
from the DSP to the installer.

![OpenVALive on the FM-1's screen: four loops playing, track 4 PAD selected, the oscilloscope above](manual/img/05-pad.png "OpenVALive on the FM-1")

This is version {{VERSION}}. You install it at your own risk; the installer can put M-VAVE's own firmware back.

- [The visual guide](https://tom-rfid.github.io/OpenVALive_SMK-37/): every gesture, loop, menu and screen, FM-1 and SMK-37 ([en français](https://tom-rfid.github.io/OpenVALive_SMK-37/fr.html)).
- [Try it in the browser](emu/): the same code as on the FM-1, with sound. No FM-1 needed.
- [Install](install/) it from Chrome or Edge, with the FM-1 connected by USB.
- The [Manual](manual/) explains the screen, the loops, the Creative Engine, scenes, effects and MIDI.
- [Download {{PKG}}](firmware/{{PKG}}) for the command-line installer: `python3 fm1_install.py {{PKG}}`.
- The [Source](https://github.com/Tom-Rfid/OpenVALive_FM-1) is MIT. The DSP core and the Live Core are portable C99:
  use them in your own synth, plugin or board. Built on fm1-base and felucca-bsp (MPL-2.0).

**What's inside:**

- **Sound:** four virtual analog engines (PolyBLEP oscillators, zero-delay-feedback filter, envelopes, LFOs, drive,
  delay, Juno-style chorus).
- **Timing:** a sample-accurate clock with swing, MIDI clock in and out.
- **Loops:** loops per track with their own length, REC, CAPTURE, 8 undo steps, 8 scenes with Morph, and
  hold-to-play effects.
- **Creative Engine:** twelve gestures that reshape a loop.
- **Connections:** velocity keys, USB-MIDI in and out, TRS MIDI in, USB audio.
- **Screen:** a real-time oscilloscope.

M-VAVE and FM-1 are trademarks of their owners. OpenVALive is not affiliated with M-VAVE.
