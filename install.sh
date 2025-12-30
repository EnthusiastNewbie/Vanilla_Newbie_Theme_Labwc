#!/bin/bash
# =================================================================
# Vanilla_Newbie - Dotfiles Installer (Versione Master)
# Autore: Enthusiast Newbie (enthusiastnewbie.com)
# =================================================================

# 1. --- CONFIGURAZIONE E PERCORSI ---
# Calcola la directory dove si trova lo script (anche se lanciato da fuori)
THEME_DIR="$(dirname "$(readlink -f "$0")")"

# Colori per un output leggibile nel terminale
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# 2. --- FUNZIONE GESTIONE ERRORI ---
# Se un comando fallisce, lo script si ferma e avvisa l'utente
handle_error() {
    if [ $1 -ne 0 ]; then
        echo -e "\n${RED}[ERRORE]${NC} Fallito: $2"
        exit 1
    fi
}

echo -e "${MAGENTA}--- 🌑 Installazione Vanilla_Newbie Dotfiles ---${NC}"
echo -e "${CYAN}[INFO]${NC} Sorgente tema: $THEME_DIR"

# 3. --- CREAZIONE CARTELLE ---
echo -e "${CYAN}[*] Preparazione directory di configurazione...${NC}"
# Creiamo tutte le cartelle necessarie, incluse quelle per i temi Openbox e GTK
mkdir -p ~/.config/{labwc,waybar,wofi,alacritty,gtk-3.0,gtk-4.0}
mkdir -p ~/.local/share/themes/Vanilla_Newbie/openbox-3
mkdir -p ~/Pictures
handle_error $? "Creazione cartelle"

# 4. --- COPIA CONFIGURAZIONI ---
echo -e "${CYAN}[*] Installazione componenti...${NC}"

# LabWC (Config, Environment, Menu, Autostart)
cp -r "$THEME_DIR/labwc/"* ~/.config/labwc/
handle_error $? "Copia LabWC"

# Waybar
cp -r "$THEME_DIR/waybar/"* ~/.config/waybar/
handle_error $? "Copia Waybar"

# Alacritty
cp "$THEME_DIR/alacritty/alacritty.toml" ~/.config/alacritty/
handle_error $? "Copia Alacritty"

# Wofi
cp -r "$THEME_DIR/wofi/"* ~/.config/wofi/
handle_error $? "Copia Wofi"

# GTK 3.0 & 4.0 (Total Black + Headerbar Magenta)
cp "$THEME_DIR/gtk/gtk.css" ~/.config/gtk-3.0/gtk.css
cp "$THEME_DIR/gtk/gtk.css" ~/.config/gtk-4.0/gtk.css
handle_error $? "Copia GTK CSS"

# Openbox Theme (Fondamentale per il nome tema in LabWC)
cp "$THEME_DIR/openbox/openbox-3/themerc" ~/.local/share/themes/Vanilla_Newbie/openbox-3/themerc
handle_error $? "Installazione tema Openbox"

# 5. --- GESTIONE WALLPAPER ---
echo -e "${CYAN}[*] Configurazione Wallpaper...${NC}"
if [ -f "$THEME_DIR/wallpaper.png" ]; then
    cp "$THEME_DIR/wallpaper.png" ~/Pictures/vanilla_wallpaper.png
    handle_error $? "Copia wallpaper"
else
    echo -e "${RED}[ATTENZIONE]${NC} wallpaper.png non trovato!"
fi

# 6. --- PERMESSI ED ESECUZIONE ---
echo -e "${CYAN}[*] Impostazione permessi e ricaricamento...${NC}"
chmod +x ~/.config/labwc/autostart
chmod +x ~/.config/labwc/scripts/*.sh 2>/dev/null

# Forziamo il tema base e il cursore per coerenza con il brand
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

# 7. --- APPLICAZIONE FINALE ---
echo -e "------------------------------------------------"
labwc --reconfigure
handle_error $? "Ricaricamento LabWC"

# Avvio manuale Waybar per riflettere i cambiamenti
~/.config/labwc/scripts/launch-waybar.sh &

echo -e "${GREEN}--- ✅ SUCCESSO: Setup Vanilla_Newbie completato! ---${NC}"
