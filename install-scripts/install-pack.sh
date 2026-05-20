#!/bin/bash
PACK_ZIP="$1"
TEMP_DIR="/tmp/art-pack-$$"

if [ ! -f "$PACK_ZIP" ]; then
    echo "❌ Erreur: ZIP non trouvé: $PACK_ZIP"
    exit 1
fi

mkdir -p "$TEMP_DIR"
unzip -q "$PACK_ZIP" -d "$TEMP_DIR"

# Créer les dossiers destination
mkdir -p "$HOME/.config/ART/usercommands/bash/photo"
mkdir -p "$HOME/.config/ART/usercommands/bash/utilitaire"
mkdir -p "$HOME/.config/ART/usercommands/python/photo"
mkdir -p "$HOME/.config/ART/usercommands/python/utilitaire"
mkdir -p "$HOME/.config/ART/usercommands/lua/photo"
mkdir -p "$HOME/.config/ART/usercommands/lua/utilitaire"
mkdir -p "$HOME/.config/ART/ctlscripts/photo"

# Copier AVEC LE CONTENU (ajouter /* pour copier les fichiers, pas le dossier!)
cp -r "$TEMP_DIR/bash/photo"/* "$HOME/.config/ART/usercommands/bash/photo/" 2>/dev/null
cp -r "$TEMP_DIR/bash/utilitaire"/* "$HOME/.config/ART/usercommands/bash/utilitaire/" 2>/dev/null
cp -r "$TEMP_DIR/python/photo"/* "$HOME/.config/ART/usercommands/python/photo/" 2>/dev/null
cp -r "$TEMP_DIR/python/utilitaire"/* "$HOME/.config/ART/usercommands/python/utilitaire/" 2>/dev/null
cp -r "$TEMP_DIR/lua/photo"/* "$HOME/.config/ART/usercommands/lua/photo/" 2>/dev/null
cp -r "$TEMP_DIR/lua/utilitaire"/* "$HOME/.config/ART/usercommands/lua/utilitaire/" 2>/dev/null
cp -r "$TEMP_DIR/ctl/photo"/* "$HOME/.config/ART/ctlscripts/photo/" 2>/dev/null

mkdir -p "$HOME/Documents/ARTcompagnon-Scripts-Help"
cp -r "$TEMP_DIR/aide"/* "$HOME/Documents/ARTcompagnon-Scripts-Help/" 2>/dev/null
rm -rf "$TEMP_DIR"

echo "✅ Pack installé!"
