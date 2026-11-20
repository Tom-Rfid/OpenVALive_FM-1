# 17 — Publier : releases et The Firmware Hub

## Releases

La CI fait le travail (`.github/workflows/build.yml`) :

| On pousse | On obtient |
|---|---|
| une branche avec une PR | une pré-release `preview-<branche>` : `.fwsc`, applis bureau, site |
| `main` | la pré-release `nightly` et le site (gh-pages) |
| un tag `vX.Y.Z` | une **release** avec `openvalive-fm1-X.Y.Z.fwsc`, `firmware.json`, les installeurs et les applis bureau |

Pour publier : fusionner dans `main`, mettre à jour `VERSION` et `CHANGELOG.md`, puis
`git tag v0.2.0 && git push --tags`. Ensuite, `scripts/update-prebuilt.sh v0.2.0` copie les fichiers de la release
dans `prebuilt/`.

## The Firmware Hub (thefirmwarehub.com)

Le hub liste les firmwares FM-1 à partir de leurs releases GitHub. Ses conditions, et où en est OpenVALive FM-1 :

| Condition | État |
|---|---|
| Open source, source complète publique | ✅ MIT, tout est dans le dépôt |
| Une release GitHub avec le `.fwsc` joint | ⏳ après la fusion dans `main` et le tag (le hub la voit sous 3 h) |
| Sa propre identité (`FM-1_` + chiffres) | ✅ `FM-1_023`, fixe : la version est dans la release (V0.1–0.2 : `FM-1_77`) |
| Le chargeur de mise à jour dans le paquet, pour pouvoir repartir | ✅ celui de fm1-base est dans chaque paquet |
| Testé sur un vrai FM-1 : installé depuis la V15 **et** depuis un autre firmware, et quitté ensuite | ⏳ à faire sur la V0.2 (ci-dessous) |
| `fmhub.json` à la racine du dépôt | ✅ `fmhub.json` (genre `groove`, play = l'émulateur, image = `docs/img/fm1-card.png`) |
| Une ligne `sounds` si le firmware contient des enregistrements | inutile : tous les sons sont synthétisés |
| Accepter les deux mémoires flash (`0x856014` et la nouvelle `0xB36014`) | ✅ le `firmware.json` de fm1-base liste les deux |

### Le test matériel demandé par le hub

1. Depuis la **V15** de M-VAVE : installer OpenVALive FM-1 (installeur web ou
   `py -3.12 fm1_install.py openvalive-fm1-0.2.0.fwsc`), jouer, SAVE, éteindre et rallumer : le set revient.
2. Depuis **un autre firmware** (Felucca, SLOOP, X0X...) : installer OpenVALive FM-1 de la même façon.
3. **Repartir** : le « retour à la V15 » de la page d'installation (ou `fm1_install.py` avec le paquet M-VAVE) doit
   marcher depuis OpenVALive FM-1.

Notez la date, la mémoire flash du FM-1 (`fm1_install.py --info`) et ce que vous avez fait dans `STATUS.md`. C'est
cette note que le hub demande.

## Le SMK-37

Le firmware des SMK-37 Elite / Pro a son propre dépôt, [OpenVALive_SMK-37](https://github.com/Tom-Rfid/OpenVALive_SMK-37)
(GPL-3.0, sur `smk37_open` de M-VAVE), avec sa propre identité, ses releases et sa page sur The Firmware Hub.
