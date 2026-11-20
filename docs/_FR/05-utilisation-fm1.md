# 05 — Utiliser le FM-1 (V0.2)

Le manuel illustré publié avec le firmware est [`targets/fm1/docs/MANUAL.md`](../../targets/fm1/docs/MANUAL.md)
(en anglais). Cette page est l'aide-mémoire. Le fonctionnement des boucles, de CAPTURE et du Creative Engine :
[16 — Le Live Core](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_FR/16-le-live-core.md).

![Au repos](../../targets/fm1/docs/img/01-ready.png) ![Quatre pistes qui jouent](../../targets/fm1/docs/img/05-pad.png)

## Commandes

| Commande | Action |
|---|---|
| **Touches** | jouent la piste sélectionnée, avec la vélocité ; aussi envoyées en USB-MIDI (canal 1) |
| **SELECT** (tourner) | piste 1 à 4 |
| **PRESET** (tourner) | son de la piste : les 65 sons d'usine famille par famille (ACID, BASS, DRUMS, PERC, LEAD, KEYS, SOFT, FX, DARK : [20](20-sons-et-touches-batterie.md)), puis USER 1–8 |
| **ALGO** (tourner) | tempo, 20 à 300 BPM |
| **K1..K4** | la page de boutons (ci-dessous) |
| **FX** | page suivante (SOUND orange / MACRO cyan / LIVE menthe / SETUP rose / USER violet) |
| **SEL** | tenu : couche des pistes (plus bas) ; appuyé : prend un son en attente (**+SEL**) ; tenu + SELECT : pointer une ligne, relâché : la sélectionner — depuis A (SEL allumé) : **échange** A et cette piste (sons, effets, octaves ; ENV sur la piste ré-échange). Le titre le dit (« SWAP TRACK A <> T2 », « SELECT LINE T3 » ; le clavier à l'écran s'efface) ; OCT− ou OCT+ avec SEL encore tenu l'annule, SELECT recommence |
| **SELECT après la piste 4** | **A**, la ligne live : les touches jouent le son propre de A en direct (PRESET), sans l'enregistrer ; ARP tapé = arpège UP / DOWN / UP-DOWN / RANDOM ; les gestes agissent sur toutes les pistes |
| **PLAY** | lecture / arrêt |
| **REC** | enregistre dans la piste pendant la lecture (au relâché) ; une prise = un pas d'annulation. **REC + la touche blanche tout à gauche, REC lâché en premier : RESET** de la boucle de la piste choisie (ENV l'annule) |
| **EDIT** | tapé en lecture : **LOOP REC** (« FULL LOOP AT END ») : EDIT clignote vite et le signe infini rouge s'affiche, la **première note** lance la prise (la ligne se peint en vert au passage de la tête de lecture), et **EDIT** à nouveau, ou un bouton de menu (SEL, SEQ, ARP, GLO, HOME, SAVE, FX, PLAY, REC), la termine : tout ce qui a été joué depuis la première note devient la boucle de la piste, sa longueur arrondie à 1, 2, 4 ou 8 mesures ; EDIT sans note : rien ; tenu + touches en lecture : **PUNCH** (enregistre par-dessus en remplaçant, jusqu'au relâchement d'EDIT ; EDIT clignote pendant l'enregistrement) |
| **ENV / LFO** | ANNULER / RÉTABLIR (8 pas) de la piste sélectionnée ; rien sur A (que du live) |
| **SAVE** + **6e touche noire** (Fa#4, entre LOAD 8 et SAVE 1), SAVE relâché d'abord | **SAVE ALL** : tout le live set (sons, boucles, scènes, tempo...), par étapes sur environ une seconde, seulement ce qui a changé ; la touche clignote quand il y a quelque chose à sauver, SAVE clignote pendant la sauvegarde. SAVE seul ne sauve rien (SAVE lui-même ne s'allume plus pour ça : la 6e noire dessous clignote) |
| **SAVE + touche blanche 1–8** / **9–16**, SAVE relâché d'abord | **LOAD** : met USER 1–8 sur la ligne choisie, tout de suite même si sa boucle joue (clavier à l'écran : violet = un son à charger, gris = vide) / **SAVE** : garde le son de la ligne en USER 1–8 (sur A : le son de A) (rose ; menthe / rose en alternance = déjà un son, remplacé) |
| **SEL + REC / SEL + PLAY** | métronome / tap tempo. REC et LOOP REC (EDIT) seulement en lecture : à l'arrêt, « PLAY FIRST » |
| **HOME tenu à l'allumage** | démarrage sûr : le set enregistré n'est pas chargé |
| **HOME** + touche blanche 1 / 2 / 3, HOME relâché d'abord | PANIC / RESTART (toutes les pistes à leur début) / STOP ALL |
| **FX** + touche blanche 1, FX relâché d'abord | remise à zéro de la ligne : effets coupés, réactivée, octave 0, niveau d'origine |
| **FX** + touche blanche 6 / 7 (Ré4 / Mi4), FX relâché d'abord | touches de batterie ORIGINAL / GM ([20](20-sons-et-touches-batterie.md)), gardé tout de suite |
| **HOME** + touche blanche 7 (Mi4), HOME relâché d'abord | **OPTION CONTROL** : DRUM KEYS (ORIGINAL / GM), **PERC 1–4** (chaque touche Ré# / Sol# du clavier de batterie sa propre percussion : Sol#3, Ré#4, Sol#4, Ré#5 ; COWBELL, CLAP, TRIANGLE, RIM, PEDAL HAT, BELL HIGH, BELL LOW, TRI MUTE, TAMBOURINE, CLAVES), KEYS ON SCREEN, **HELP AT START** (les pages d'aide après le logo), **T1–T4 / A NEW SOUND** (la page qu'un nouveau son amène sur cette ligne : KEEP ou une page). EDIT : la valeur par défaut de la ligne |
| **GLO + SEL** | **MAP CONTROL** : les pages de boutons dans l'ordre de FX (PRESET en déplace une, ALGO l'affiche / la masque), puis ce que font K1–K4 sur MACRO, LIVE, EQ et USER (PRESET la cible, ALGO l'option ; une ligne changée en cyan). Parmi les cibles, **PAN** : un bouton place une piste à gauche / droite dans la stéréo (cran au milieu), la commande stéréo du FM-1. EDIT : la valeur par défaut de la ligne. La dernière ligne de SOUNDS, MAP CONTROL et OPTION CONTROL (MENU) passe de l'un à l'autre avec PRESET ou OCT ; n'importe quel bouton de menu ferme et garde |
| **PRESET**, puis OCT− / OCT+ dans les 2 s (ou tant qu'un son attend SEL) | famille de sons précédente / suivante, affichée devant le nom : F1 ACID, F2 BASS, F3 DRUMS, F4 PERC (sons courts), F5 LEAD, F6 KEYS (stabs, accords, claviers), F7 SOFT (nappes, cordes, chœur), F8 FX (montées, zaps, météo), F9 DARK (drones, les sons durs), puis USER |
| **FX** (tap) sur une piste de batterie | les pages font SOUND → MACRO → LIVE → SETUP → USER → **EQ** → **DRUM EQ** (rouge ; l'ordre et les pages affichées : MAP CONTROL) : K1 graves (BASS), K2 aigus (TREBLE), K3 le niveau de la grosse caisse, K4 celui des charleys (une piste synthé la saute) |
| **HOME** + touche blanche 8 (Fa4), HOME relâché d'abord | **SOUNDS** : les sons que PRESET propose. L'écran reste ouvert HOME relâché (les deux mains libres). Une ligne par famille F1–F9 : toute la ligne rouge = famille masquée, « F2 » en bleu = en partie, en vert = tout proposé ; un carré par son ; sur la ligne choisie, le nom du son choisi (et sous le titre sa position « 3/5 », sa famille et ON / HIDDEN). Le nom de chaque famille prend sa couleur. SELECT la ligne, PRESET le son, SEL proposé (vert) / masqué (rouge), OCT− / OCT+ toute la famille masquée / proposée. Dernière ligne **→ NEXT PAGE** (l'aide dit « <- PRESET -> ») : PRESET ou OCT passe à **MAP CONTROL** (OCT− : **OPTION CONTROL**), qui ont la même dernière ligne ; une liste plus longue que l'écran a une barre de défilement à droite. N'importe quel bouton de menu (HOME, FX, ARP, SEQ, GLO, SAVE) ferme et enregistre. Un son masqué continue de jouer là où il est ; PRESET et les sauts de famille le sautent |
| **HOME** + 4e touche noire (Do#4), HOME relâché d'abord, ou **SEL** + 3e touche noire (La#3), tout de suite | **LOOP EDIT** de la piste choisie : SELECT passe d'une note à l'autre (elle sonne), une touche lui donne sa hauteur, K1 position (1/16), K2 longueur, K3 vélocité, K4 hauteur ; REC efface la note, EDIT en ajoute une un 1/16 plus loin, **EDIT tenu + touches** ajoute des notes au même endroit (un accord) ; PLAY lance la lecture ; HOME ou SEL pour sortir. Toute l'édition = un seul UNDO (ENV) |
| **OCT− / OCT+** | octave de la ligne sélectionnée, −3 à +3 (T1..T4 et A ont chacune la leur ; un son USER ramène son octave) ; une LOOP en cours : ×2 / ÷2 |
| **MASTER** | volume |

### Pages de boutons

| Page | K1 | K2 | K3 | K4 |
|---|---|---|---|---|
| SOUND, synthé | CUTOFF | RESO | ENV | FX (delay) |
| SOUND, batterie | TUNE | DECAY | CUTOFF | DRIVE |
| SOUND, mode contrôleur | CC 74 | CC 71 | CC 75 | CC 94 |
| MACRO (toutes les pistes) | ENERGY | SPACE | TENSION | DENSITY |
| LIVE | MORPH (entre les deux dernières scènes rappelées) | SWING | PUMP (sidechain) | LEVEL (volume de piste, 0–100, 67 = tel quel) |
| SETUP (préparation) | MIDI IN | XFADE (coupe, 1, 2, 4 mesures) | QUANTIZE | BARS (1–8 mesures ; les mesures ajoutées répètent la boucle) |
| USER | ce que tu leur as donné (MAP CONTROL) | | | |
| EQ (la sortie, orange) | BASS graves (±12 dB, 120 Hz) | MID médiums (±12 dB) | TREBLE aigus (±12 dB, 8 kHz) | MID FREQ (250 Hz – 4 kHz) |

Les boutons de MACRO, LIVE et EQ peuvent recevoir d'autres cibles dans MAP CONTROL, comme ceux de USER.

### Maintenir un bouton de couche + une touche blanche (F3 = touche 1 ... G5 = touche 16)

| Couche | Touches |
|---|---|
| **ARP** créatif | 1 MUTATE · 2 HUMANIZE · 3 FILL · 4 SIMPLIFY · 5/6 ROTATE </> · 7 REVERSE · 8/9 TRANSPOSE −/+ · 10 EXPAND · 11 CONTRACT · 12 CHANCE · 13 RATCHET · 14/15 OCTAVE −/+ — force = vélocité ; sur une piste, relâcher ARP avant la touche applique (menthe), la touche d'abord annule |
| **GLO** scènes (GLO relâché avant la touche = pris, la touche d'abord = annulé) | 1–8 **LOAD** : rappelle la scène 1–8 (en lecture : à la mesure suivante, coupe nette ou fondu) · 9–16 **SAVE** : mémorise la scène 1–8 (roses sur un clavier à l'écran) · GLO + PLAY chaîne de scènes · ARP + SEL **SOUND EDIT** (tous les paramètres du son de la piste : formes, filtre, enveloppes, LFO calés sur le tempo, matrice de modulation) · GLO + SEL **MAP CONTROL** (ce que font les 4 boutons de la page USER : un effet, un volume, une macro, un CC MIDI…) · GLO + ALGO mesures par scène |
| **SEQ** jeu : titre « ∞ DIV / FILTER ». Les boucles (touches 1–5), sur une piste : SEQ relâché avant la touche = allumé, verrouillé, refait = éteint (sur A : tout de suite) ; SEQ tapé = la boucle se relâche ; OCT−/OCT+ = boucle ×2 / ÷2, OCT+ depuis 1/16 atteint **1/32** (sans touche). Les effets et les breaks (6–16) agissent **tout de suite** : tenir = tant qu'on tient, taper = verrouillé | Par groupes. Le temps : 1–5 LOOP 1 mesure…1/16 · 6 **SLICER** (la piste choisie hachée en doubles croches, sur le temps ; sur A : tout le mix ; OCT− / OCT+ pendant qu'il tourne : 1/4 … 1/64) · 7 ENVOI DE DELAY. Les filtres : 8 FILTRE FERMÉ · 9 FILTRE OUVERT. Le son : 10 DRIVE · 11 CRUSH. Les coupures : 12 BREAK · 13 SOLO · 14 DRUMS ONLY · 15 ALL OUT. 16 TOUT COUPER — les pistes retirées reviennent sur la mesure suivante ; une LOOP en cours : sa piste passe en rouge, SEQ clignote ; un effet pris : blanc sur vert en bas, 0,5 s |
| **SEL** pistes | 1–4 muet, tout de suite (allumée : joue ; clignote vite : coupée) · 5 (libre) · 6 à 16 **validés au relâché** (SEL relâché d'abord, la touche encore tenue), comme ARP / SEQ / GLO : 6 **A VOL** (plus bas) · 7 QUANTIZE · 8 HORLOGE MIDI EN ENTRÉE · 9 HORLOGE EN SORTIE · 10–15 EUCLIDE 3..8 coups / 16 · 16 **PLAY MODE** LIVE ↔ FULL MIDI (aussi dans OPTION CONTROL). Touches noires : **1re (Fa#3) MUET LES 4** (A continue ; clignote vite quand tout est coupé) · **3e (La#3) LOOP EDIT**, tout de suite (touche violette, LE en bleu) · **4e (Do#4) CLEAR TRACK** (rouge ; validé au relâché ; A : toutes les pistes). **A VOL** (6e blanche, Ré4, validé au relâché) : les niveaux des pistes qui jouent et celui de A vont vers un même niveau — la moyenne des 2 du milieu avec 4 pistes, des 2 plus fortes avec 2 ou 3 — pas à pas sur la boucle la plus longue (une boucle de 4 mesures : 4 mesures), puis le mode s'arrête (refait : arrêté ; un LEVEL tourné à la main l'arrête ; la touche monte et descend lentement, 2 s, pendant qu'il tourne ; « A VOL » à droite du titre de SEL) |

## L'écran

```
T4  DRUMS 808            120 BPM
                     6%     PLAY
───────────────────────────────── oscilloscope
1 ▬  ▬   ▬  ▬  │  ▬   ▬          les quatre boucles, la tête de lecture,
2 ▬▬    ▬▬   ▬▬│     ▬▬          la piste sélectionnée en blanc,
3 ▬    ▬▬▬     │   ▬             une piste muette en grisé
4              │
CUTOFF  RESO   ENV    SEQ
55      20     58     25
            OCT +0       SOUND
```

## Le groupe

| Piste | Son | Voix |
|---|---|---|
| 1 | ACID 303 : façon TB-303, glide, accents | 4 (ACID lui-même est mono) |
| 2 | BASS : mono legato + glide, scie + sub, drive | 1 |
| 3 | LEAD : mono, carré PWM + scie, vibrato, delay | 2 |
| 4 | DRUMS 808 : grosse caisse, caisse claire, clap, charleys, toms, rim, cowbell (à chaque octave : do = grosse caisse, ré = caisse claire, fa# = charley, sol# = triangle...) | — |

Chaque piste peut prendre n'importe quel son (PRESET). 11 voix au total gardent quatre pistes chargées dans le
budget CPU ; au-dessus de 90 %, la piste la plus chargée perd une voix.

## MIDI

Entrée (**USB** et **jack TRS**, tous canaux) : joue la piste sélectionnée, enregistrée et capturée comme les
touches ; CC 74/71 cutoff/résonance, 73/72 attaque/release, 5 glide, 1 vibrato, 93/94 chorus/delay, 120/123 tout
coupé ; pitch bend ±2. **Horloge MIDI** en entrée (start, stop, continue, tempo) quand CLOCK IN est actif.

**Mode contrôleur** (SEL + touche blanche 16, « local off ») : les touches et les boutons envoient seulement du
MIDI (canal = numéro de piste, boutons = CC 74 71 75 94) ; les boucles continuent de jouer dans le FM-1. Le FM-1
devient un clavier MIDI.

Sortie (**USB** seulement, pas de prise MIDI OUT sur le FM-1) : les touches sur le canal de la piste sélectionnée, les boucles des pistes
1–4 sur les canaux 1–4, l'horloge MIDI et start/stop quand CLOCK OUT est actif. L'appareil apparaît comme
« OpenVALive FM-1 ».

### Synchroniser avec une boîte à rythmes (Roland T-8...) ou un logiciel

- **La T-8 mène** (sans ordinateur) : MIDI OUT de la T-8 → MIDI IN du FM-1 (jack TRS). Sur le FM-1 : SEL + touche
  blanche 8 (CLOCK IN), et SEL maintenu + PRESET tourné jusqu'à **CLOCK only** (la T-8 envoie aussi ses notes :
  basse sur le canal 2, batterie sur le 10). Appuyer sur START sur la T-8.
- **Le FM-1 mène** : son horloge sort seulement en USB (pas de prise MIDI OUT) : via un ordinateur ou un boîtier
  hôte USB MIDI vers la T-8, réglée en « MIDI Clock Sync » AUTO, USB ou MIDI. Sur le FM-1 : SEL + touche blanche 9
  (CLOCK OUT).
- Câbles : la T-8 utilise le **MIDI TRS type A**. Si un simple câble TRS ne donne rien, passer par des adaptateurs
  DIN. Les prises SYNC de la T-8 (impulsions analogiques) ne peuvent pas être lues par le FM-1.
- Le MIDI entrant est horodaté à son arrivée : le tempo est suivi sans gigue.
- Un program change n rappelle la scène n + 1 ; la pression (aftertouch, ou appuyer plus fort sur une touche)
  ouvre le filtre.

## Audio USB

fm1-base inclut l'audio USB : le FM-1 est aussi une **carte son** pour l'ordinateur. Enregistrez-le directement
dans votre logiciel. Sans rien dans la prise casque, le haut-parleur reçoit une coupure des graves à 130 Hz (il ne
peut pas jouer plus grave, seulement saturer).
