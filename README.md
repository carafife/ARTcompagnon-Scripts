# ARTcompagnon-Scripts

Pack de scripts CTL, Python, Bash et Lua pour ARTcompagnon.

## Structure du Depot

bash/
  - photo/
  - utilitaire/
python/
  - photo/
  - utilitaire/
lua/
  - photo/
  - utilitaire/
ctl/
  - photo/

install-scripts/
  - install-pack.sh

## Installation

1. Telecharger le pack .zip depuis Releases
2. Ouvrir ARTcompagnon → Scripts ART → Installer Pack
3. Selectionner le fichier .zip
4. Le script d'installation ajoute les scripts aux dossiers ART

## Important

Les scripts legacy (smart_masking.sh, nind_denoise_raw.sh) sont preserves lors de l'installation.
Les nouveaux scripts sont ajoutes sans ecraser les existants.

---

## 📋 Créer vos propres usercommands

Si vous souhaitez lancer d autres scripts ou logiciels depuis ART (Smart Masking, Hugin, HDR Merge, etc.), voici comment créer vos propres fichiers usercommand.

### Structure d un usercommand

Créez un fichier `.txt` dans `~/.config/ART/usercommands/` :

````
[ART UserCommand]
Label=* NOM_DE_VOTRE_APPLICATION
Command=* /chemin/complet/vers/script.sh
FileType=* raw|jpg|jpeg|tif|tiff|png
NumArgs=1
```

## Licence

MIT - Cree avec amour par carafife
