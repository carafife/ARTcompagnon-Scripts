#!/bin/bash

PACK_ZIP="$1"
TEMP_DIR="/tmp/art-pack-$$"

if [ ! -f "$PACK_ZIP" ]; then
    echo "❌ Erreur: ZIP non trouvé: $PACK_ZIP"
    exit 1
fi

mkdir -p "$TEMP_DIR"
unzip -q "$PACK_ZIP" -d "$TEMP_DIR"

mkdir -p "$HOME/.config/ART/ctlscripts"
mkdir -p "$HOME/.config/ART/usercommands/python"
mkdir -p "$HOME/.config/ART/usercommands/bash"
mkdir -p "$HOME/.config/ART/usercommands/lua"

[ -d "$TEMP_DIR/ctl" ] && unzip -n "$PACK_ZIP" "ctl/*" -d "$HOME/.config/ART/ctlscripts/" 2>/dev/null
[ -d "$TEMP_DIR/python" ] && unzip -n "$PACK_ZIP" "python/*" -d "$HOME/.config/ART/usercommands/" 2>/dev/null
[ -d "$TEMP_DIR/bash" ] && unzip -n "$PACK_ZIP" "bash/*" -d "$HOME/.config/ART/usercommands/" 2>/dev/null
[ -d "$TEMP_DIR/lua" ] && unzip -n "$PACK_ZIP" "lua/*" -d "$HOME/.config/ART/usercommands/" 2>/dev/null

rm -rf "$TEMP_DIR"

echo "✅ Pack installé!"
