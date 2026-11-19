# 14 — Le simulateur web et le site du projet

## Essayer dans le navigateur

fm1-base compile **l'app FM-1 entière** — les mêmes `app.c`, `src/` et `core/` — en WebAssembly, avec une page qui
dessine l'écran, les touches et les boutons du FM-1 et joue le son par Web Audio. Souris, écran tactile et clavier
d'ordinateur fonctionnent.

- En ligne : <https://tom-rfid.github.io/OpenVALive_FM-1/emu/>
- Dans le dépôt : `prebuilt/web/emu/` (à servir, voir plus bas)

## Le site

La CI construit un site complet avec `tools/make_site.py` de fm1-base :

| Chemin | Quoi |
|---|---|
| `/` | page d'accueil (`targets/fm1/site/landing.md`) |
| `/emu/` | l'émulateur |
| `/install/` | l'**installateur web** : flashe le FM-1 depuis Chrome ou Edge par Web MIDI, sans Python |
| `/manual/` | le manuel (`targets/fm1/docs/MANUAL.md` et ses captures) |
| `/firmware/` | le paquet `.fwsc` |

Il est poussé sur la branche `gh-pages` à chaque push sur `main` et à chaque tag. **Réglage à faire une fois**
sur le dépôt : Settings → Pages → Build and deployment → Branch : `gh-pages` / root.

## Le lancer en local

Les pages WebAssembly doivent être servies en HTTP (pas ouvertes comme fichiers) :

```bash
cd prebuilt/web
python3 -m http.server 8000
# ouvrir http://localhost:8000/emu/   (et /install/ pour flasher depuis cette page)
```

## Le construire soi-même

Il faut emscripten (la CI utilise 3.1.74 ; le paquet Ubuntu 3.1.6 est trop ancien pour fm1-base) :

```bash
python3 ~/fm1-base/tools/build.py targets/fm1 --web               # -> targets/fm1/build/emu/
python3 ~/fm1-base/tools/build.py targets/fm1 --release 0.1.0     # un paquet de release pour l'installateur
python3 ~/fm1-base/tools/make_site.py targets/fm1 targets/fm1/build/openvalive-0.2.0.fwsc 0.2.0 build/site
```

## Les captures d'écran

Les captures de la doc viennent du simulateur fm1-base, scriptées par `targets/fm1/tests/screens.txt` :

```bash
targets/fm1/build/host/openvalive_host targets/fm1/tests/screens.txt targets/fm1/docs/img
```
On change l'interface, on relance, et les images du manuel suivent. (Le simulateur affiche CPU 0 % : seul
l'appareil le mesure.)
