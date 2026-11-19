#!/usr/bin/env python3
"""The drum keys pictures of doc 20 (docs/img/drum-keys-{original,gm}-{en,fr}.svg): one octave, every octave the same.

    python3 scripts/make-drum-keys.py
"""
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "docs" / "img"
NAMES = {36: ("KICK", "GROSSE CAISSE"), 37: ("RIM", "RIMSHOT"), 38: ("SNARE", "CAISSE CLAIRE"),
         39: ("CLAP", "CLAP"), 40: ("SNARE 2", "CAISSE CLAIRE 2"), 41: ("FLOOR TOM", "TOM BASSE"),
         42: ("CLOSED HAT", "CHARLEY FERMÉ"), 43: ("FLOOR TOM HI", "TOM BASSE AIGU"), 44: ("PEDAL HAT", "CHARLEY PIED"),
         45: ("LOW TOM", "TOM GRAVE"), 46: ("OPEN HAT", "CHARLEY OUVERT"), 47: ("LOW-MID TOM", "TOM MÉDIUM"),
         48: ("MID TOM", "TOM MOYEN"), 50: ("HIGH TOM", "TOM AIGU"), 56: ("COWBELL", "COWBELL"), 81: ("TRIANGLE", "TRIANGLE")}
# the 12 keys C .. B of each map: GM note numbers (app/src/ui_input.c drum_key_note); None: chosen in the settings
MAPS = {"original": [36, 37, 38, 56, 40, 50, 42, 48, 81, 45, 46, 41], "gm": [36 + n for n in range(12)]}
CHOSEN = {"original": (3, 8)}
KEYS = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
WHITE = [0, 2, 4, 5, 7, 9, 11]
BLACK = {1: 0, 3: 1, 6: 3, 8: 4, 10: 5}      # key -> the white key it follows
TEXT = {"en": ("lit on a drum track", "blinks every half second", "chosen in the settings (DRUM D# / DRUM G#)",
               "Every octave repeats these 12 keys. GM = the General MIDI note sent and recorded."),
        "fr": ("allumée sur une piste de batterie", "clignote toutes les demi-secondes",
               "au choix dans les réglages (DRUM D# / DRUM G#)",
               "Chaque octave répète ces 12 touches. GM = la note General MIDI envoyée et enregistrée.")}
W, H, KW, KH, BW, BH, X0, Y0 = 860, 450, 112, 300, 72, 185, 38, 40
LIT, BLINK = "#ffd628", "#ee5a24"


def led(gm):
    return BLINK if gm in (36, 46) else (LIT if gm in (38, 40, 42) else None)


def lines(name, width):
    return name.split(" ", 1) if len(name) > width and " " in name else [name]


def svg(mapname, lang):
    keys = MAPS[mapname]
    chosen = CHOSEN.get(mapname, ())
    li = 1 if lang == "fr" else 0
    o = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" font-family="Helvetica, Arial, sans-serif">',
         f'<rect width="{W}" height="{H}" rx="14" fill="#16161c"/>']
    for i, k in enumerate(WHITE):
        x, gm = X0 + i * KW, keys[k]
        o.append(f'<rect x="{x}" y="{Y0}" width="{KW - 4}" height="{KH}" rx="6" fill="#f4f4f6" stroke="#888"/>')
        if led(gm):
            o.append(f'<circle cx="{x + KW / 2 - 2}" cy="{Y0 + KH - 26}" r="9" fill="{led(gm)}"/>')
        for j, part in enumerate(lines(NAMES[gm][li], 9)):
            o.append(f'<text x="{x + KW / 2 - 2}" y="{Y0 + 210 + 17 * j}" font-size="15" font-weight="700" '
                     f'fill="#16161c" text-anchor="middle">{part}</text>')
        o.append(f'<text x="{x + KW / 2 - 2}" y="{Y0 + KH - 50}" font-size="13" fill="#555" text-anchor="middle">'
                 f'{KEYS[k]} · GM {gm}</text>')
    for k, after in BLACK.items():
        x, gm = X0 + (after + 1) * KW - BW / 2 - 2, keys[k]
        stroke = ' stroke="#ffd628" stroke-dasharray="5 3" stroke-width="2"' if k in chosen else ' stroke="#000"'
        o.append(f'<rect x="{x}" y="{Y0}" width="{BW}" height="{BH}" rx="5" fill="#2a2a33"{stroke}/>')
        if led(gm):
            o.append(f'<circle cx="{x + BW / 2}" cy="{Y0 + BH - 20}" r="8" fill="{led(gm)}"/>')
        for j, part in enumerate(lines(NAMES[gm][li], 7)):
            o.append(f'<text x="{x + BW / 2}" y="{Y0 + 70 + 15 * j}" font-size="12" font-weight="700" fill="#f4f4f6" '
                     f'text-anchor="middle">{part}</text>')
        o.append(f'<text x="{x + BW / 2}" y="{Y0 + 125}" font-size="11" fill="#aaa" text-anchor="middle">{KEYS[k]}</text>')
        o.append(f'<text x="{x + BW / 2}" y="{Y0 + 140}" font-size="11" fill="#aaa" text-anchor="middle">GM {gm}</text>')
    lit, blink, choice, foot = TEXT[lang]
    y = Y0 + KH + 34
    o.append(f'<circle cx="{X0 + 8}" cy="{y - 5}" r="8" fill="{LIT}"/><text x="{X0 + 24}" y="{y}" font-size="14" '
             f'fill="#eee">{lit}</text>')
    o.append(f'<circle cx="{X0 + 368}" cy="{y - 5}" r="8" fill="{BLINK}"/><text x="{X0 + 384}" y="{y}" font-size="14" '
             f'fill="#eee">{blink}</text>')
    if chosen:
        o.append(f'<rect x="{X0}" y="{y + 12}" width="16" height="12" fill="none" stroke="{LIT}" stroke-dasharray="4 2"/>'
                 f'<text x="{X0 + 24}" y="{y + 23}" font-size="14" fill="#eee">{choice}</text>')
    o.append(f'<text x="{X0}" y="{y + 50}" font-size="13" fill="#bbb">{foot}</text>')
    o.append("</svg>")
    return "\n".join(o)


if __name__ == "__main__":
    for m in MAPS:
        for lang in ("en", "fr"):
            (OUT / f"drum-keys-{m}-{lang}.svg").write_text(svg(m, lang))
    print("docs/img: drum-keys-{original,gm}-{en,fr}.svg")
