#!/usr/bin/env python3
"""Builds the README / docs pictures from the simulator screenshots.

    python3 ~/fm1-base/tools/build.py targets/fm1 --host
    targets/fm1/build/host/openvalive_host targets/fm1/tests/screens.txt targets/fm1/docs/img
    python3 scripts/make-composites.py

docs/img/fm1-screens.png  four screens side by side (README banner)
docs/img/fm1-hero.png     one screen at 2x (a square card)
docs/img/fm1-card.png     240 x 240 for The Firmware Hub (fmhub.json "image")
docs/img/fm1-sounds.png   the scope of a few sounds (targets/fm1/tests/sounds.txt, into targets/fm1/build/sounds)
"""
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SHOTS = ROOT / "targets/fm1/docs/img"
OUT = ROOT / "docs/img"
BANNER = ["10-capture", "11-creative", "05-pad", "12-morph"]
GAP, BG = 20, (18, 18, 22)


def shot(name):
    return Image.open(SHOTS / f"{name}.png").convert("RGB")


def banner():
    images = [shot(n) for n in BANNER]
    w = len(images) * 240 + (len(images) + 1) * GAP
    out = Image.new("RGB", (w, 240 + 2 * 12), BG)
    for i, im in enumerate(images):
        out.paste(im, (GAP + i * (240 + GAP), 12))
    out.save(OUT / "fm1-screens.png", optimize=True)


def hero():
    shot("05-pad").resize((480, 480), Image.NEAREST).save(OUT / "fm1-hero.png", optimize=True)
    shot("05-pad").save(OUT / "fm1-card.png", optimize=True)


SOUNDS = [("acid", "ACID 303"), ("sub", "SUB"), ("brass", "BRASS"), ("pad", "PAD"), ("grunge", "GRUNGE"),
          ("screech", "SCREECH"), ("whale", "WHALE"), ("init", "INIT"), ("dtight", "DRUMS TIGHT")]


def sounds():
    """3 x 3: the header and the scope of each sound (the scope's auto-gain shows its shape)"""
    src = ROOT / "targets/fm1/build/sounds"
    if not (src / "snd-acid.png").exists():
        return
    w, h = 240, 92
    out = Image.new("RGB", (3 * w + 4 * GAP, 3 * h + 4 * GAP), BG)
    for i, (name, _) in enumerate(SOUNDS):
        im = Image.open(src / f"snd-{name}.png").convert("RGB").crop((0, 0, w, h))
        out.paste(im, (GAP + (i % 3) * (w + GAP), GAP + (i // 3) * (h + GAP)))
    out.save(OUT / "fm1-sounds.png", optimize=True)


if __name__ == "__main__":
    banner()
    hero()
    sounds()
    print("docs/img: fm1-screens.png, fm1-hero.png, fm1-card.png, fm1-sounds.png")
