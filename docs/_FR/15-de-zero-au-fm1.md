# 15 — De zéro au FM-1 flashé : comment le projet a démarré

L'histoire de la première nuit, étape par étape, avec chaque fausse piste — pour que la personne suivante (ou le
prochain fork) le refasse en une heure au lieu d'une nuit.

## 1. Écrire le DSP avant de toucher au matériel

D'abord un cœur C99 portable (`core/`) : oscillateurs PolyBLEP, filtre ZDF, enveloppes, LFO, delay, chorus, moteur
VA 4 voix, parseur MIDI — avec un **simulateur PC** qui rend des WAV et mesure le CPU. Sur PC : 33 s de démo
rendues 300 fois plus vite que le temps réel, aucun NaN, aliasing 15–20 dB sous des oscillateurs naïfs.

## 2. Choisir la bonne base : fm1-base, pas Felucca

En lisant Felucca (le firmware FM-1 le plus connu) : il est en **GPL-3.0** — copier son code rendrait tout le
projet GPL. Son auteur a séparé la couche matériel dans **felucca-bsp** (MPL-2.0), et Charles Vestal a construit
**fm1-base** (MPL-2.0) par-dessus : écran, touches, audio, MIDI, stockage, simulateur, émulateur, outils de build
et d'installation. Avec eux, notre code reste en MIT.

Faits matériels appris dans leurs docs, tous intégrés au code :
- l'audio tourne à **44 117,647 Hz** (24 MHz / 544), pas 48 kHz, en **Q23 dans des int32**, 256 frames par interruption ;
- CPU 360 MHz, FPU simple précision, **pas de libm** (utiliser `fastmath.h`), `double` refusés ;
- pas de prise MIDI OUT : la sortie MIDI passe par l'USB ;
- le SMK-37 est « prévu, pas commencé » dans felucca-bsp.

## 3. Écrire l'app FM-1 et la lancer dans le simulateur

`targets/fm1/` : touches avec vélocité, 4 boutons, presets, oscilloscope, CPU, sauvegarde, MIDI in et out, la
file d'événements entre UI et audio. Le **simulateur fm1-base** a fait tourner l'app entière avec un script
(13 vérifications, captures, WAV) avant tout contact avec le matériel.

## 4. L'environnement de build sous Windows

| Étape | Ce qui s'est passé | Solution |
|---|---|---|
| WSL | `wsl --install`, puis redémarrage | normal |
| clone de fm1-base | a marché | — |
| clone du SDK JieLi | **demande d'identifiant GitHub** | le dépôt GitHub n'est plus public : utiliser **Gitee**, tag `AC79NN_SDK_V1.2.1_2023-12-13` (un autre firmware FM-1 documentait la même solution) |
| vérif de la toolchain | `ls ~/.jieli/toolchain/bin` échoue | le compilateur est dans `pi32v2/bin/` — rien n'était cassé |
| unzip | zip absent de Téléchargements | le retrouver, ou `explorer.exe .` |
| build simulateur | `No module named 'PIL'` | `sudo apt install python3-pil` |

## 5. Le premier vrai build JieLi

`fatal error: 'string.h' file not found` : l'appareil n'a pas de libc. Retrait de `<string.h>`, `memset`,
`memmove`, `NULL` du cœur, ajout du **test « FM-1 sans libc »** pour qu'un PC le détecte désormais. Deuxième
build : réussi — image 100 Ko, RAM 36 Ko, aucun double, accès registres propres.

## 6. Flasher depuis Windows

| Étape | Ce qui s'est passé | Solution |
|---|---|---|
| commandes | commandes PowerShell tapées dans Ubuntu | côté Windows = PowerShell |
| `pip install python-rtmidi` | demandait un compilateur C++ | Python 3.15 trop récent : **`py install 3.12`** et `py -3.12 ...` |
| `fm1_install.py --info` | `MIDI inputs: (none)` | le FM-1 n'était pas encore visible (câble / délai) ; deuxième essai : `FM-1_102 [running]` (un autre firmware custom était installé) |
| installation | `done: the FM-1 runs FM-1_023` | — |

## 7. Sur l'appareil

L'écran est apparu comme dans le simulateur, le son est sorti, et le CPU a affiché : **4 % à vide, ~5 % par
voix, 26 % au pire** (PAD, 4 notes, chorus + delay). Beaucoup de marge.

## 8. Ensuite : rendre tout ça réutilisable

Tout ce qui a été fait cette nuit-là est devenu outil : `INSTALL-WINDOWS.bat` (WSL → build → Python 3.12 → flash),
`setup.sh`, les tests, la CI qui compile firmware, émulateur, site avec installateur web et applications bureau,
l'application bureau elle-même (plus besoin de Linux pour jouer), et ces docs.

## Leçons

1. Simuler d'abord : l'app FM-1 a marché au premier flash parce qu'elle avait tourné dans le simulateur.
2. Lire la licence de chaque fichier avant de lire son code.
3. Quand `git` demande un mot de passe sur un dépôt public, l'adresse est fausse.
4. Sous Windows, figer Python en 3.12 pour tout ce qui utilise `python-rtmidi`.
5. Transformer chaque surprise en test (`string.h` → le test sans libc) ou en étape de script.
