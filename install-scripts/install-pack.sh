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

[ -d "$TEMP_DIR/ctl-packs/pack-basic/ctl" ] && unzip -n "$PACK_ZIP" "ctl-packs/pack-basic/ctl/*" -d "$HOME/.config/ART/ctlscripts/" 2>/dev/null && mv "$HOME/.config/ART/ctlscripts/ctl-packs/pack-basic/ctl"/* "$HOME/.config/ART/ctlscripts/" 2>/dev/null && rm -rf "$HOME/.config/ART/ctlscripts/ctl-packs" 2>/dev/null
[ -d "$TEMP_DIR/python-packs/pack-basic/python" ] && unzip -n "$PACK_ZIP" "python-packs/pack-basic/python/*" -d "$HOME/.config/ART/usercommands/" 2>/dev/null && mv "$HOME/.config/ART/usercommands/python-packs/pack-basic/python"/* "$HOME/.config/ART/usercommands/python/" 2>/dev/null && rm -rf "$HOME/.config/ART/usercommands/python-packs" 2>/dev/null
[ -d "$TEMP_DIR/bash-packs/pack-basic/bash" ] && unzip -n "$PACK_ZIP" "bash-packs/pack-basic/bash/*" -d "$HOME/.config/ART/usercommands/" 2>/dev/null && mv "$HOME/.config/ART/usercommands/bash-packs/pack-basic/bash"/* "$HOME/.config/ART/usercommands/bash/" 2>/dev/null && rm -rf "$HOME/.config/ART/usercommands/bash-packs" 2>/dev/null
[ -d "$TEMP_DIR/lua-packs/pack-basic/lua" ] && unzip -n "$PACK_ZIP" "lua-packs/pack-basic/lua/*" -d "$HOME/.config/ART/usercommands/" 2>/dev/null && mv "$HOME/.config/ART/usercommands/lua-packs/pack-basic/lua"/* "$HOME/.config/ART/usercommands/lua/" 2>/dev/null && rm -rf "$HOME/.config/ART/usercommands/lua-packs" 2>/dev/null

rm -rf "$TEMP_DIR"

echo "✅ Pack installé!"
