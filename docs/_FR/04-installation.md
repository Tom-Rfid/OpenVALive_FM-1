# 04 — Installation

Tous les chemins aboutissent au même fichier, `openvalive-fm1-X.Y.fwsc`, installé sur le FM-1.

> **Avant tout flash** : sauvegarde tes presets et projets. Pour revenir au firmware officiel M-VAVE (V15 ou
> V16), l'installateur web de Felucca le propose : <https://hugelton.github.io/Felucca/> (Chrome ou Edge). Sur les
> FM-1 récents avec une flash UC25HQ80, lis d'abord les notes de version de Felucca 1.8.2.

## A. Depuis le navigateur (le plus simple, aucun outil)

Ouvre l'**installateur** du site du projet, <https://tom-rfid.github.io/OpenVALive_FM-1/install/>, dans Chrome ou
Edge, branche le FM-1 en USB, suis la page. Il utilise Web MIDI et le même protocole de mise à jour que
l'installateur en ligne de commande. Le site propose aussi l'**émulateur** pour essayer d'abord.

*(Le site est publié par la CI une fois Pages activé sur le dépôt : Settings → Pages → Branch `gh-pages`.)*

## B. Le firmware déjà compilé

**Windows, le plus simple** : dans la dernière [release](https://github.com/Tom-Rfid/OpenVALive_FM-1/releases),
télécharge **`OpenVALive-FM1-X.Y.zip`**, dézippe-le, branche le FM-1, double-clique sur **`FLASH-FM1.bat`**
(ou clic droit sur `flash.ps1` → *Exécuter avec PowerShell*). Le script prépare Python 3.12 au premier lancement.

Sinon : les fichiers de la dernière release (`OpenVALive-FM1-X.Y.Z.zip`). Installe-le avec
l'installateur web, ou en ligne de commande (Windows, Linux, macOS) :

```bash
pip install mido python-rtmidi          # Windows : py -3.12 -m pip install mido python-rtmidi
python3 fm1_install.py --info           # ne modifie rien : dit ce que le FM-1 fait tourner
python3 fm1_install.py openvalive-fm1-0.2.0.fwsc
```
`fm1_install.py` et `fm1ports.py` sont à côté du firmware dans le zip de la release (ils viennent de fm1-base).

## C. Windows, compiler soi-même, automatiquement

1. Télécharge le projet (bouton vert **Code → Download ZIP** sur GitHub) et dézippe-le.
2. Double-clique sur **`INSTALL-WINDOWS.bat`**.
3. Laisse-toi guider. Le script :
   - installe **WSL et Ubuntu 24.04** s'ils manquent. La première fois : **redémarre**, ouvre *Ubuntu* dans le
     menu Démarrer pour créer ton utilisateur Linux, puis **relance** `INSTALL-WINDOWS.bat` ;
   - dans Ubuntu (ton mot de passe Ubuntu est demandé une fois, pour `sudo`) : installe les paquets,
     **fm1-base**, la **toolchain JieLi**, le **SDK JieLi** (depuis Gitee), lance les **tests**, compile le **firmware** ;
   - copie le résultat dans `Bureau\OpenVALive-FM1` ;
   - installe **Python 3.12** et `mido` + `python-rtmidi` côté Windows ;
   - propose d'**installer le firmware** sur le FM-1 branché.

Lancé seul (sans le reste du projet), le script **demande le chemin du zip**, ou télécharge le projet depuis
GitHub si tu laisses vide. Plus tard, pour réinstaller : double-clic sur `Bureau\OpenVALive-FM1\FLASH-FM1.bat`.

```powershell
powershell -ExecutionPolicy Bypass -File scripts\windows\install.ps1 -Zip C:\chemin\OpenVALive.zip
powershell -ExecutionPolicy Bypass -File scripts\windows\install.ps1 -NoFlash
```

Les messages des scripts sont en anglais (la communauté est internationale).

## D. Linux (ou WSL déjà installé), un script

```bash
git clone --recursive https://github.com/Tom-Rfid/OpenVALive_FM-1
bash OpenVALive_FM-1/scripts/wsl/setup.sh                 # tout : outils, tests, firmware
bash OpenVALive_FM-1/scripts/wsl/setup.sh --host-only     # simulateur + tests seulement
bash ~/OpenVALive/scripts/wsl/build-fm1.sh --out /mnt/c/Users/MOI/Desktop/OpenVALive-FM1   # recompiler
```

Sous Linux natif, le FM-1 est visible directement : `pip install mido python-rtmidi` puis
`python3 ~/fm1-base/tools/fm1_install.py targets/fm1/build/openvalive.fwsc`. La toolchain JieLi n'existe que pour
Linux x86-64 ; sur macOS, fm1-base sait l'exécuter dans un conteneur Docker (non testé ici).

## E. À la main, étape par étape

Ce que font les scripts — pour comprendre ou dépanner. L'histoire complète, avec tous les pièges rencontrés,
est dans [15 — De zéro au FM-1](15-de-zero-au-fm1.md) ; le fonctionnement du build dans
[11 — Compilation du firmware](11-compilation-du-firmware.md).

1. **WSL** (PowerShell administrateur) : `wsl --install -d Ubuntu-24.04`, redémarrer, ouvrir Ubuntu, créer l'utilisateur.
2. **Paquets** (Ubuntu) :
   ```bash
   sudo apt update
   sudo apt install -y git build-essential python3 python3-pil python3-numpy curl xz-utils unzip rsync
   ```
3. **fm1-base, toolchain, SDK** :
   ```bash
   cd ~
   git clone --recursive https://github.com/charlesvestal/fm1-base
   bash fm1-base/tools/get_toolchain.sh
   git clone --depth 1 --branch AC79NN_SDK_V1.2.1_2023-12-13 \
       https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK.git ~/fw-AC79_AIoT_SDK
   echo 'export JIELI_TOOLCHAIN=$HOME/.jieli/toolchain' >> ~/.bashrc
   echo 'export AC79_SDK=$HOME/fw-AC79_AIoT_SDK' >> ~/.bashrc
   source ~/.bashrc
   ```
4. **Build** :
   ```bash
   git clone --recursive https://github.com/Tom-Rfid/OpenVALive_FM-1 ~/OpenVALive && cd ~/OpenVALive
   FM1_BASE=~/fm1-base sh tests/run_tests.sh
   python3 ~/fm1-base/tools/build.py targets/fm1          # -> targets/fm1/build/openvalive.fwsc
   ```
5. **Flash** (PowerShell sous Windows : WSL ne voit pas l'USB-MIDI) :
   ```powershell
   py install 3.12
   py -3.12 -m pip install mido python-rtmidi
   cd $HOME\Desktop\OpenVALive-FM1
   py -3.12 fm1_install.py --info
   py -3.12 fm1_install.py openvalive.fwsc
   ```

Une installation réussie se termine par `done: the FM-1 runs FM-1_023…`. Une installation interrompue reprend en
relançant la même commande.

## Après l'installation

- L'écran affiche `OPENVALIVE INIT`, l'oscilloscope et quatre barres.
- Le son sort (monter MASTER) ; la touche 4 à l'octave 0 donne un La à 220 Hz.
- En haut à droite, `CPU` : ~4 % à vide, ~24 % avec 4 notes.

Un problème ? [10 — Dépannage](10-depannage.md).
