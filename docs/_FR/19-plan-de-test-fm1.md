# 19 — Plan de test sur le FM-1 (V0.2)

À faire dans l'ordre. Note pour chaque ligne : OK, ou ce que tu as vu (une photo de l'écran aide). Si quelque chose
bloque, passe à la suite : chaque section est indépendante.

Testé pour l'instant sur la dernière révision matérielle du FM-1 (sans le logo M-VAVE sous l'écran ; novembre 2026).
Une révision plus ancienne (logo sous l'écran) est bienvenue comme testeur.

## 0. Installer

| # | Action | Attendu |
|---|---|---|
| 0.1 | Télécharger le zip de la dernière release ou de la préversion `preview-dev` (firmware, `fm1_install.py`, `fm1ports.py`, `FLASH-FM1.bat`) | — |
| 0.2 | `py -3.12 fm1_install.py --info` | la mémoire flash (`856014` ou `B36014`) et le firmware actuel ; **note-les** |
| 0.3 | `FLASH-FM1.bat` (ou `py -3.12 fm1_install.py openvalive-0.0.3.fwsc`) | `done: the FM-1 runs FM-1_023` |
| 0.4 | Le FM-1 redémarre | l'écran : T1 INIT, 120 BPM, STOP, quatre pistes vides |

## 1. Son et CPU

| # | Action | Attendu |
|---|---|---|
| 1.1 | Au repos | CPU affiché ≤ 5 % |
| 1.2 | Accord de 4 notes sur la piste 1 | son propre, CPU noté |
| 1.3 | PRESET sur toute la liste (piste 1) | 17 synthés puis DRUMS 808 / TIGHT / LOFI / IRON ; rien ne craque ; note ceux qui sonnent trop fort ou trop faible |
| 1.4 | Piste 4 (DRUMS 808) : do = grosse caisse, ré = caisse claire, fa# = charley, la# = charley ouvert | sons de batterie nets, le charley fermé coupe l'ouvert |
| 1.5 | Haut-parleur seul, puis casque | moins de saturation dans les graves au haut-parleur ; son complet au casque |
| 1.6 | Appuyer plus fort sur une touche tenue | le filtre s'ouvre, le vibrato s'approfondit |

## 2. Boucles

| # | Action | Attendu |
|---|---|---|
| 2.1 | Transport arrêté, piste 2 : jouer 4 notes, puis EDIT (CAPTURE) | la boucle tourne tout de suite, en rythme avec ce que tu jouais |
| 2.2 | ENV puis LFO | annuler / rétablir |
| 2.3 | SEL + REC (métronome), REC à l'arrêt, puis PLAY et REC | à l'arrêt « PLAY FIRST » ; en lecture l'enregistrement |
| 2.4 | SEL + PLAY tapé 4 fois | le tempo suit |
| 2.5 | ARP + touche blanche 1 (fort puis doux) | MUTATE plus ou moins marqué |
| 2.6 | SEL + touche blanche 11 sur la piste 4 | Euclide 5/16 sur la grosse caisse |
| 2.7 | Les 4 pistes jouent ensemble, accords tenus | CPU noté (sous 80 % attendu) ; si « VOX » baisse, note-le |

## 3. Performance

| # | Action | Attendu |
|---|---|---|
| 3.1 | SEQ + taper la touche blanche 3 | LOOP 1/4 reste ; l'écran l'affiche ; retaper l'arrête |
| 3.2 | SEQ + tenir la touche blanche 12 (BREAK) en fin de phrase, relâcher | la batterie sort tout de suite et revient pile sur le premier temps |
| 3.3 | SEQ + taper 7 puis 9 (FILTER SHUT + DELAY THROW) | les deux ensemble ; touche 16 = tout coupé |
| 3.4 | GLO + 9 (mémoriser), changer le son, GLO + 10 ; en lecture GLO + 1 | « NEXT BAR » : la scène arrive sur la mesure suivante |
| 3.5 | FX ×3 (SETUP), K2 = 2 BARS, puis GLO + 2 en lecture | fondu sur 2 mesures |
| 3.6 | FX ×2 (LIVE), K1 MORPH | glisse entre les deux dernières scènes rappelées |
| 3.7 | FX (MACRO) : ENERGY à fond, puis SPACE, TENSION, DENSITY | tout le morceau change d'un geste ; retour à 50 = le son d'origine |
| 3.8 | LIVE, K3 PUMP à 70 avec la batterie et un pad | le pad « pompe » sur la grosse caisse |
| 3.9 | 2 ou 3 scènes mémorisées, GLO + PLAY | les scènes s'enchaînent toutes les 4 mesures |
| 3.10 | Piste en ACID, notes fortes et douces, legato | les notes fortes « squelchent », les liées glissent |

## 4. Mémoire

| # | Action | Attendu |
|---|---|---|
| 4.1 | SAVE + touche blanche 9 (SAVE lâché en premier), puis changer de son, puis SAVE + touche blanche 1 | « SAVED USER 1 » (vert) ; « LOADED USER 1 » : le son revient |
| 4.2 | SAVE + 1re touche noire (SAVE ALL, SAVE lâché en premier), attendre « SAVED », éteindre, rallumer | tout revient : boucles, sons, scènes, tempo |
| 4.3 | Tenir HOME en allumant jusqu'à l'écran | « SAFE START », set vide ; rallumer normalement : le set revient |

## 5. MIDI

| # | Action | Attendu |
|---|---|---|
| 5.1 | Logiciel de musique : notes vers le FM-1 | jouent la piste sélectionnée |
| 5.2 | SEL + touche 16 (CONTROLLER) | l'en-tête affiche MIDI 1 ; les touches ne jouent plus le FM-1, le logiciel reçoit les notes et les CC des boutons |
| 5.3 | T-8 → MIDI IN du FM-1, SETUP K1 = CLOCK, SEL + touche 7 (CLOCK IN), START sur la T-8 | le FM-1 démarre avec la T-8 et reste calé plusieurs minutes |
| 5.4 | SEL + touche 8 (CLOCK OUT) avec un logiciel | le logiciel suit le tempo du FM-1 |

## 6. Repartir (pour The Firmware Hub)

| # | Action | Attendu |
|---|---|---|
| 6.1 | Installer un autre firmware (Felucca, SLOOP...) puis OpenVALive de nouveau | marche dans les deux sens |
| 6.2 | Revenir à la V15 de M-VAVE depuis OpenVALive | le FM-1 d'origine revient |

Envoie-moi le tableau rempli : je corrige ce qui ne va pas et je règle les niveaux et les limites de voix.
