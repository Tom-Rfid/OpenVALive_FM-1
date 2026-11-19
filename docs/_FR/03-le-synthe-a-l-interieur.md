# 03 — Le synthé à l'intérieur : OpenVALive CORE, et comment c'est câblé

Ce dépôt contient la **moitié FM-1** d'OpenVALive. Le synthé, le Live Core et les écrans de l'app sont ceux
d'[OpenVALive CORE](https://github.com/Tom-Rfid/OpenVALive_CORE) (MIT), inclus ici comme sous-module git dans `va/`. Cette page est la version
courte ; la complète est dans ce dépôt ([architecture](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_FR/03-architecture-technique.md)).

## Les couches

```
 matériel FM-1      touches, 14 boutons, 7 encodeurs, écran 240x240, codec, USB-MIDI, MIDI DIN, flash
      │
 fm1-base           la plateforme (MPL-2.0) : boot, pilotes, API plat.h, interruption audio, stockage, simulateur, web
      │                                                                      ── ce dépôt : targets/fm1/
 targets/fm1        app.h (nom, carte flash, options) · app.c → va/app/openvalive_app.c · ols_dsp.c → va/app/ols_dsp.c
      │                                                                      ── le sous-module : va/
 va/app             l'instrument : pages, couches, CONTROL MAP, SOUND EDIT, sauvegarde, MIDI   (unity build, -Os)
 va/core/live       le Live Core : horloge, 4 pistes, REC, CAPTURE, undo, scènes, Morph, Creative Engine
 va/core/engines    VA (2 osc + sub + bruit, filtre, 2 env, 2 LFO, matrice de modulation, effets) · DRUM (famille 808)
 va/core/dsp        PolyBLEP, ZDF SVF, ADSR, LFO, delay, chorus, phaser    (ols_dsp.c, -O2, fastmath)
```

## Une note, de la touche au haut-parleur

| Étape | Où | Quand |
|---|---|---|
| 1. Une touche descend : fm1-base la lit, avec sa vélocité (`APP_TOUCH`) | fm1-base `lib/touch.h` | boucle principale |
| 2. L'app en fait une note sur la piste choisie, ou un geste de couche (scène, effet, creative…) | `va/app/src/ui_input.c` | boucle principale, ~60 Hz |
| 3. Elle pousse un `ols_event_t` dans la file sans verrou (l'interface ne touche jamais un moteur) | `va/app/src/app_events.c` | boucle principale |
| 4. L'interruption audio lit la file et le MIDI entrant, puis rend 256 trames | `va/app/src/app_audio.c` | toutes les 5,8 ms |
| 5. Le Live Core joue les boucles à l'échantillon près, enregistre, envoie les notes aux 4 moteurs | `va/core/live/live.c` | dans le rendu |
| 6. Chaque moteur rend ; la modulation et les calculs coûteux tournent toutes les 32 échantillons | `va/core/engines/va/` | dans le rendu |
| 7. Le mix sort en int32 Q23 stéréo à 44 117,647 Hz (24 MHz / 544) | audio fm1-base | dans le rendu |

## Ce qu'ajoute le FM-1

| Quoi | Où |
|---|---|
| Nom `OPENVALIVE`, couleur du splash, identité `FM-1_023` | `targets/fm1/app.h`, `fm1.toml` |
| Carte flash : réglages 0xFC000, calibration 0xDC000, live set 0xD8000 + 0xDA000, sons perso 0xD6000, CONTROL MAP 0xD4000 | `APP_STORE_MAP` dans `app.h` |
| Vélocité et pression des touches, délestage de voix en surcharge | `APP_TOUCH`, `APP_OVERLOAD` |
| Horodatage MIDI, coupe-bas du haut-parleur, pas de Bluetooth | `fm1.toml` |
| Site, manuel, captures, scripts du simulateur (80 vérifications) | `targets/fm1/site`, `docs/`, `tests/` |

## Changer le synthé

Un changement du son, du Live Core ou des écrans se fait **dans OpenVALive CORE**, s'y teste, puis ce dépôt
déplace sa version fixée :

```bash
sh scripts/va.sh status            # quelle version est fixée
sh scripts/va.sh update            # va/ au dernier dev    (ou : use v0.4.0 · use <commit> pour revenir en arrière)
FM1_BASE=~/fm1-base sh tests/run_tests.sh
git add va && git commit -m "va: v0.4.0"
```

Windows : `.\scripts\va.ps1 status | update | use v0.4.0 | reset`. Détails : [18 — règles](18-regles-git-et-publication.md).

| Pour comprendre | Lire (OpenVALive CORE) |
|---|---|
| le Live Core (boucles, CAPTURE, scènes, Morph) | [16](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_FR/16-le-live-core.md) |
| écrire un moteur | [07](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_FR/07-creer-un-moteur.md) |
| le contrat de plateforme de l'app | [app/README.md](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/app/README.md) |
| tests et mesures | [08](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_FR/08-tests-et-mesures.md) |
