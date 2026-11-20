# 10 — Dépannage

Toutes les erreurs rencontrées pendant la mise au point, et leur solution.

## Préparer l'environnement

**`git clone` demande `Username for 'https://github.com'`**
Un dépôt public ne demande jamais d'identifiant : l'adresse ne mène à aucun dépôt accessible. Ctrl+C, ne rien
taper. Cas connu : le SDK JieLi sur GitHub (`Jieli-Tech/fw-AC79_AIoT_SDK`) demande maintenant un compte ; utiliser
Gitee (les scripts le font) :
```bash
git clone --depth 1 --branch AC79NN_SDK_V1.2.1_2023-12-13 \
    https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK.git ~/fw-AC79_AIoT_SDK
```
Si tu as tapé ton mot de passe GitHub, il a été refusé (GitHub n'accepte plus les mots de passe en ligne de
commande) ; le changer ne coûte rien.

**`ls ~/.jieli/toolchain/bin` : No such file**
Normal : le compilateur est dans `~/.jieli/toolchain/pi32v2/bin/clang`. `JIELI_TOOLCHAIN` doit pointer vers
`~/.jieli/toolchain`.

**`ModuleNotFoundError: No module named 'PIL'`**
`sudo apt install -y python3-pil` (fm1-base génère les polices de l'écran).

**`unzip: cannot find or open …zip`**
Le zip n'est pas là. Le chercher : `find /mnt/c/Users/$USER* -iname 'openvalive*.zip' 2>/dev/null`, ou ouvrir
l'Explorateur depuis Ubuntu avec `explorer.exe .` et y glisser le fichier.

**Commandes PowerShell tapées dans Ubuntu** (`cd $HOME\Desktop` → `/home/userDesktop…`, `py: command not found`)
Les commandes Windows se tapent dans **PowerShell** (`PS C:\…>`), les commandes Linux dans **Ubuntu**
(`user@PC:~$`).

## Compiler le firmware

**`fatal error: 'string.h' file not found`**
Le firmware FM-1 est compilé sans libc standard. Pas de `<string.h>`, pas de `memmove`, pas de `NULL` dans
`core/` (voir [07](https://github.com/Tom-Rfid/OpenVALive_CORE/blob/dev/docs/_FR/07-creer-un-moteur.md)). Le test « FM-1 sans libc » détecte ce cas sur PC.

**`soft-double routines linked`**
Une constante sans `f` (`0.5` au lieu de `0.5f`) ou un calcul en `double`. La compilation stricte des tests
(`-Wdouble-promotion`) le signale.

**`cp: cannot stat '…/OPENVALIVE.fwsc'`**
Le fichier est en minuscules : `openvalive.fwsc` (build de dev) ou `openvalive-fm1-X.Y.fwsc` (release).

**`warning: fm1.toml has no install, screenshot`**
Seules les releases exigent ces champs ; le `fm1.toml` d'OpenVALive les a.

## Installer sur le FM-1

**`python-rtmidi` : `Unknown compiler(s)` / `metadata-generation-failed`**
Python trop récent (3.14, 3.15) : pas de `python-rtmidi` précompilé. Utiliser 3.12 :
```powershell
py install 3.12
py -3.12 -m pip install mido python-rtmidi
py -3.12 fm1_install.py --info
```

**`error: FM-1 not found` / `MIDI inputs: (none)`**
Windows ne voit aucun appareil MIDI. Dans l'ordre : FM-1 allumé ; câble de **données** (beaucoup de câbles USB-C
ne font que charger) ; pas de hub ; FL Studio et tout logiciel MIDI fermés ; il apparaît dans le Gestionnaire de
périphériques. Il faut parfois quelques secondes après le branchement. WSL ne voit pas l'USB : installer depuis
Windows, ou avec l'installateur web.

**L'installation s'est interrompue**
Relancer la même commande : `fm1_install.py` reprend un FM-1 resté en mode mise à jour, et le chargeur ne réécrit
que les secteurs qui diffèrent. En dernier recours, l'installateur web de Felucca remet le firmware officiel :
<https://hugelton.github.io/Felucca/>.

## Sur l'appareil

**Pas de son** : monter MASTER ; vérifier le casque ; regarder `VOICES` (une touche doit afficher 1/4).

**`CPU` au-delà de 90 %** : l'app retire des voix automatiquement (`VOICES x/3`, `x/2`…). Signaler le preset et
le nombre de notes.

**Clics en tournant un encodeur vite** : possibles en V0.1 (pas de lissage) ; premier objectif du système de
paramètres de la V0.2.

## Application bureau

**« No audio output device could be opened »** : un autre logiciel tient la sortie en exclusif, ou il n'y a pas
de sortie ; essayer `--rate 48000`.

**Le clavier MIDI ne fait rien** : `--list`, puis `--midi N` (Windows) ou `--midi /dev/snd/midiC1D0` (Linux,
utilisateur dans le groupe `audio`). Fermer les DAW qui tiennent le port.

**Les notes du clavier d'ordinateur sont courtes** : un terminal signale les appuis, pas les relâchements. Tenir
la touche (la répétition automatique la fait durer) ou utiliser un clavier MIDI.
