#!/bin/bash

# ----------------------------------------------------------------------
# Script : find-launcher.sh
# Description : Recherche toutes les façons de lancer un programme
#               (natif, Flatpak, AppImage, Snap) et les affiche joliment.
#               Propose une boucle pour de nouvelles recherches.
# Usage       : ./find-launcher.sh
# ----------------------------------------------------------------------

set -o pipefail

# ---------- Couleurs et style ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # Pas de couleur

# ---------- Fonctions d'affichage ----------
print_header() {
    clear
    echo -e "${BOLD}${BLUE}══════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  🔍  Program Launcher Finder${NC}"
    echo -e "${BOLD}${BLUE}══════════════════════════════════════════════${NC}"
}

print_section() {
    echo -e "\n${BOLD}${MAGENTA}─── $1 ───${NC}"
}

# ---------- 1. Natif (PATH + répertoire courant) ----------
get_native() {
    local prog="$1"
    local paths=()

    while IFS= read -r line; do
        [[ -n "$line" ]] && paths+=("$line")
    done < <(which -a "$prog" 2>/dev/null)

    if [[ -x "./$prog" ]]; then
        if ! printf '%s\n' "${paths[@]}" | grep -Fxq "./$prog"; then
            paths+=("./$prog")
        fi
    fi

    if [[ ${#paths[@]} -eq 0 ]]; then
        echo -e "${RED}  ✘ Aucun exécutable natif trouvé (PATH + dossier courant).${NC}"
        return 1
    else
        echo -e "${GREEN}  ✔ Exécutable(s) natif(s) trouvé(s) :${NC}"
        for p in "${paths[@]}"; do
            echo -e "    ${YELLOW}►${NC} $p"
        done
        return 0
    fi
}

# ---------- 2. Flatpak ----------
get_flatpak() {
    local prog="$1"

    if ! command -v flatpak &>/dev/null; then
        echo -e "${RED}  ✘ Flatpak n'est pas installé.${NC}"
        return 1
    fi

    local flatpak_list
    flatpak_list=$(flatpak list --app --columns=application,name 2>/dev/null)
    if [[ -z "$flatpak_list" ]]; then
        echo -e "${RED}  ✘ Aucune application Flatpak installée.${NC}"
        return 1
    fi

    local matches
    matches=$(echo "$flatpak_list" | awk -v name="$prog" 'BEGIN{IGNORECASE=1} $2 ~ name {print $1}')

    if [[ -z "$matches" ]]; then
        echo -e "${RED}  ✘ Aucun Flatpak correspondant à '${prog}' trouvé.${NC}"
        return 1
    else
        echo -e "${GREEN}  ✔ Flatpak correspondant(s) :${NC}"
        while IFS= read -r appid; do
            echo -e "    ${YELLOW}►${NC} flatpak run $appid"
        done <<< "$matches"
        return 0
    fi
}

# ---------- 3. AppImage ----------
get_appimage() {
    local prog="$1"
    local found_any=false

    local search_dirs=("." "$HOME/Applications" "$HOME/.local/bin" "/opt" "/usr/local/bin")

    for dir in "${search_dirs[@]}"; do
        [[ ! -d "$dir" ]] && continue

        local maxdepth=3
        [[ "$dir" == "." ]] && maxdepth=1

        while IFS= read -r -d '' file; do
            if [[ "$found_any" == false ]]; then
                echo -e "${GREEN}  ✔ AppImage(s) trouvée(s) :${NC}"
                found_any=true
            fi
            echo -e "    ${YELLOW}►${NC} $file"
        done < <(find "$dir" -maxdepth "$maxdepth" -type f -iname "*${prog}*.AppImage" -executable -print0 2>/dev/null)
    done

    if [[ "$found_any" == false ]]; then
        echo -e "${RED}  ✘ Aucune AppImage correspondante trouvée dans les dossiers usuels.${NC}"
        return 1
    fi
    return 0
}

# ---------- 4. Snap ----------
get_snap() {
    local prog="$1"

    if ! command -v snap &>/dev/null; then
        echo -e "${RED}  ✘ Snap n'est pas installé.${NC}"
        return 1
    fi

    local snap_list
    snap_list=$(snap list 2>/dev/null)
    if [[ -z "$snap_list" ]]; then
        echo -e "${RED}  ✘ Aucun paquet Snap installé.${NC}"
        return 1
    fi

    local matches
    matches=$(echo "$snap_list" | awk -v name="$prog" 'NR>1 && tolower($1) ~ tolower(name) {print $1}')

    if [[ -z "$matches" ]]; then
        echo -e "${RED}  ✘ Aucun Snap correspondant à '${prog}' trouvé.${NC}"
        return 1
    else
        echo -e "${GREEN}  ✔ Snap(s) correspondant(s) :${NC}"
        while IFS= read -r snap_name; do
            echo -e "    ${YELLOW}►${NC} snap run $snap_name"
        done <<< "$matches"
        return 0
    fi
}

# ---------- Fonction principale de recherche ----------
perform_search() {
    local prog="$1"

    echo -e "${BOLD}Recherche des lanceurs pour '${CYAN}${prog}${NC}${BOLD}'...${NC}"

    print_section "Natif (PATH + dossier courant)"
    get_native "$prog"

    print_section "Flatpak"
    get_flatpak "$prog"

    print_section "AppImage"
    get_appimage "$prog"

    print_section "Snap"
    get_snap "$prog"

    echo -e "\n${BOLD}${BLUE}══════════════════════════════════════════════${NC}"
}

# ---------- Boucle principale ----------
main() {
    while true; do
        print_header

        echo -ne "${BOLD}Entrez le nom du programme (ou 'q' pour quitter) : ${NC}"
        read -r prog

        # Quitter si l'utilisateur entre 'q' ou 'Q'
        if [[ "$prog" =~ ^[qQ]$ ]]; then
            echo -e "\n${BOLD}${GREEN}Au revoir !${NC}"
            exit 0
        fi

        if [[ -z "$prog" ]]; then
            echo -e "${RED}Nom vide, veuillez entrer quelque chose.${NC}"
            sleep 1
            continue
        fi

        # Lance la recherche
        perform_search "$prog"

        # Demande si on relance
        echo -ne "\n${BOLD}Voulez-vous faire une autre recherche ? (o/N) : ${NC}"
        read -r answer
        if [[ ! "$answer" =~ ^[oOyY]$ ]]; then
            echo -e "\n${BOLD}${GREEN}Au revoir !${NC}"
            exit 0
        fi
        # Sinon, la boucle recommence et le clear est fait dans print_header
    done
}

# Appel du point d'entrée
main
