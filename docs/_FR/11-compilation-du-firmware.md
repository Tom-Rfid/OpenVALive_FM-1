# 11 — Comment le firmware est compilé (toolchain JieLi, fm1-base, paquet)

Ce qui se passe entre `core/*.c` et un fichier `.fwsc` que le FM-1 accepte — pour le recompiler, le réparer, ou
reprendre la méthode sur un autre appareil JieLi.

## La puce et ses outils

Le FM-1 tourne sur une **JieLi AC791N / WL82** (cœur `pi32v2`, 360 MHz, FPU simple précision, ~512 Ko de SRAM,
1 Mo de flash SPI NOR). JieLi fournit :

| Outil | Où | Licence |
|---|---|---|
| **Toolchain** : clang 4.0.1 pour pi32v2, éditeur de liens, objdump | `https://pkgman.jieliapp.com/s/linux-toolchain` (Linux x86-64 seulement), récupérée par `fm1-base/tools/get_toolchain.sh` dans `~/.jieli/toolchain` | propriétaire |
| **SDK AC79** | `https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK` (la copie GitHub demande maintenant un compte) | Apache-2.0 |

Du SDK, seuls **trois fichiers** servent, à assembler le paquet de mise à jour : `uboot.boot`, `cfg_tool.bin`,
`cfg/eq_cfg_hw.bin`, du tag `AC79NN_SDK_V1.2.1_2023-12-13`. Le build vérifie leur SHA-256 : un miroir avec les
mêmes fichiers fonctionne aussi. Aucune bibliothèque JieLi n'est liée à OpenVALive (pas de Bluetooth ni WiFi).

## Les couches logicielles

```
targets/fm1 + va/ (OpenVALive)    app.h, app.c, ols_dsp.c → va/app, va/core      MIT
fm1-base                         plateforme : plat.h, device/*, host/*, tools  MPL-2.0
felucca-bsp (sous-module)        chip/, boards/fm1/, loader/                   MPL-2.0
JieLi                            toolchain + 3 fichiers du SDK                 téléchargés
```

- **felucca-bsp** (Leo Kuroshita, Hügelton Instruments) est la couche matériel extraite de Felucca : horloges,
  interruptions, flash, USB (classes MIDI, série, audio), l'écran ST7789, le scan des touches, le DMA audio, le
  chargeur de mise à jour et son protocole.
- **fm1-base** (Charles Vestal) est tout ce qui est au-dessus du matériel : dessin et polices, panneau, LED,
  callback audio, MIDI USB et TRS, stockage, lecteur d'écran, simulateur, émulateur web, script de build, outils
  de paquet et site avec installateur web.
- L'**app** fournit `app_init`, `app_render`, `app_frame`, `app_panic`… (voir `targets/fm1/app.h`).

## Ce que fait `tools/build.py targets/fm1`

1. Lit `targets/fm1/fm1.toml` (nom, identité `id_prefix`, noms USB, unités `o2`, options).
2. Génère des en-têtes : les polices depuis les TTF (Pillow), les mots du lecteur d'écran (`words.tsv`).
3. Compile le **chargeur de mise à jour** (felucca-bsp `loader/`) en image RAM → `build/loader/ota.bin`.
4. Compile avec `$JIELI_TOOLCHAIN/pi32v2/bin/clang -mcpu=r3 -mfprev1 -ffp-contract=off` :
   - `device/unity.c` : toute la plateforme **et** l'app (`app.c` inclut `src/*`) en une unité, en `-Os` ;
   - chaque unité `o2` (`ols_dsp.c`, qui inclut `core/`) à part, en `-O2`.
5. Édite les liens avec le script de l'app : emplacement en flash, code en RAM (`.ram_text`), `.data/.bss`, `.pool`.
6. **Vérifie** l'image :
   - aucune routine soft-double (un `double` s'est glissé) ;
   - aucune multiplication 64 bits à côté d'une lecture 16 bits (erratum connu du pi32v2, felucca-bsp `docs/CPU.md`) ;
   - aucun accès aux registres hors de felucca-bsp ;
   - tailles : image, code RAM, `.data+.bss`, pool face à leurs limites.
7. Assemble `build/openvalive.bin` + le chargeur + les 3 fichiers du SDK en **`openvalive.fwsc`** avec `fm1pkg.py` de
   felucca-bsp, estampillé avec l'identité (`FM-1_023` en dev, `FM-1_023` en release).
8. Écrit `firmware.json` (pour les catalogues de firmwares).

Sortie de notre premier build réel :
```
ok    no soft-double routines (single-precision FPU only)
ok    image 102660 B; RAM code .ram_text 5100 B of 32768; RAM .data+.bss 36564 B of 98304; pool 102152 B of 344064
ok    register access: felucca-bsp only (device/, include/ and the app clean)
package  openvalive.fwsc  616003 B, identity FM-1_023
```

Autres modes du même script : `--host` (le simulateur, avec le compilateur du PC), `--web` (l'émulateur,
emscripten), `--release X.Y` (identité de release, refuse les métadonnées manquantes), et `tools/make_site.py`
(le site : accueil, installateur web, manuel, émulateur).

## Ce que le cœur doit respecter pour compiler là-bas

Le compilateur JieLi est ancien (clang 4) et il n'y a **pas de libc** au-delà de `memset`/`memcpy`/`memcmp` :

| Règle | Pourquoi | Vérifié par |
|---|---|---|
| pas de `<string.h>`, `<stdio.h>`, `<stdlib.h>`, `<stddef.h>` | les en-têtes n'existent pas | test « FM-1 sans libc » |
| pas de `NULL` (écrire `0`), pas de `memmove` | absents | idem |
| `float` uniquement, suffixe `f` | le soft-double est refusé | `-Wdouble-promotion -Werror` + vérification du build |
| `dsp_tanf` etc., pas `tanf` | pas de libm : `OLS_FASTMATH` passe par `fastmath.h` de fm1-base | test « fastmath = libm » |

Notre premier build JieLi a échoué précisément sur `string.h` — le test « sans libc » a été ajouté la même nuit
pour qu'un PC le détecte désormais.

## Comment le firmware arrive sur le FM-1

`fm1_install.py` (ou l'installateur web) parle le protocole de mise à jour en **SysEx USB-MIDI** :
1. le firmware en cours (tout firmware basé sur felucca-bsp, ou celui de M-VAVE) lit des morceaux du paquet et le vérifie ;
2. il redémarre dans le chargeur de mise à jour ;
3. le chargeur lit tout le paquet et écrit la flash — en mode rapide, seulement les secteurs de 4 Ko qui diffèrent (table de CRC) ;
4. le FM-1 redémarre, l'installateur vérifie la nouvelle identité : `done: the FM-1 runs FM-1_023`.

Une installation interrompue laisse le FM-1 en mode mise à jour : relancer l'installateur la termine.

## Dans la CI

`.github/workflows/build.yml` fait tout cela sur un Ubuntu vierge : récupère fm1-base, la toolchain et le SDK,
lance les tests, compile le firmware de release, l'émulateur et le site, compile les applications bureau, et
publie (gh-pages, releases). Un fork obtient la même chaîne gratuitement.
