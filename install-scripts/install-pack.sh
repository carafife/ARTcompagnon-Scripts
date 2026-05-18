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
mkdir -p "$HOME/.config/ART/ctlscripts"
mkdir -p "$HOME/.config/ART/usercommands/python"
mkdir -p "$HOME/.config/ART/usercommands/bash"
mkdir -p "$HOME/.config/ART/usercommands/lua"

# Copier directement les fichiers au bon endroit
cp -r "$TEMP_DIR/ctl-packs/pack-basic/ctl"/* "$HOME/.config/ART/ctlscripts/" 2>/dev/null
cp -r "$TEMP_DIR/python-packs/pack-basic/python"/* "$HOME/.config/ART/usercommands/python/" 2>/dev/null
cp -r "$TEMP_DIR/bash-packs/pack-basic/bash"/* "$HOME/.config/ART/usercommands/bash/" 2>/dev/null
cp -r "$TEMP_DIR/lua-packs/pack-basic/lua"/* "$HOME/.config/ART/usercommands/lua/" 2>/dev/null

rm -rf "$TEMP_DIR"

echo "✅ Pack installé!"
