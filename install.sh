#!/bin/bash
# =================================================================
# Vanilla_Newbie - Dotfiles Installer (Versione Master)
# Autore: Enthusiast Newbie (enthusiastnewbie.com)
# Descrizione: Installa e registra ufficialmente il tema per GTK/WM
# =================================================================

# 1. --- CONFIGURAZIONE E PERCORSI ---
THEME_DIR="$(dirname "$(readlink -f "$0")")"

# Colori per un output leggibile
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# 2. --- FUNZIONE GESTIONE ERRORI ---
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
# Creiamo le cartelle per config e per il tema di sistema locale
mkdir -p ~/.config/{labwc,waybar,wofi,alacritty,gtk-3.0,gtk-4.0}
mkdir -p ~/.local/share/themes/Vanilla_Newbie/{openbox-3,gtk-3.0,gtk-4.0}
mkdir -p ~/Pictures
handle_error $? "Creazione cartelle"

# 4. --- COPIA CONFIGURAZIONI (HOME CONFIG) ---
echo -e "${CYAN}[*] Installazione componenti in ~/.config ...${NC}"

# LabWC
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

# GTK (Iniezione diretta per app correnti)
cp "$THEME_DIR/gtk/gtk.css" ~/.config/gtk-3.0/gtk.css
cp "$THEME_DIR/gtk/gtk.css" ~/.config/gtk-4.0/gtk.css
handle_error $? "Copia GTK CSS in .config"

# 5. --- REGISTRAZIONE UFFICIALE TEMA (PER FASTFETCH) ---
echo -e "${CYAN}[*] Registrazione ufficiale del tema Vanilla_Newbie...${NC}"

# Copia CSS nella cartella dei temi per riconoscimento globale
cp "$THEME_DIR/gtk/gtk.css" ~/.local/share/themes/Vanilla_Newbie/gtk-3.0/gtk.css
cp "$THEME_DIR/gtk/gtk.css" ~/.local/share/themes/Vanilla_Newbie/gtk-4.0/gtk.css

# Openbox (Necessario per LabWC)
cp "$THEME_DIR/openbox/openbox-3/themerc" ~/.local/share/themes/Vanilla_Newbie/openbox-3/themerc
handle_error $? "Installazione tema Openbox"

# Creazione file index.theme (Questo permette a fastfetch di vedere il nome)
cat <<EOF > ~/.local/share/themes/Vanilla_Newbie/index.theme
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=Vanilla_Newbie
Comment=Tema ufficiale di Enthusiast Newbie
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=Vanilla_Newbie
MetacityTheme=Vanilla_Newbie
IconTheme=Papirus
CursorTheme=Adwaita
EOF
handle_error $? "Creazione index.theme"

# 6. --- GESTIONE WALLPAPER ---
echo -e "${CYAN}[*] Configurazione Wallpaper...${NC}"
if [ -f "$THEME_DIR/wallpaper.png" ]; then
    cp "$THEME_DIR/wallpaper.png" ~/Pictures/vanilla_wallpaper.png
    handle_error $? "Copia wallpaper"
else
    echo -e "${RED}[ATTENZIONE]${NC} wallpaper.png non trovato!"
fi

# 7. --- PERMESSI ED IMPOSTAZIONI DI SISTEMA ---
echo -e "${CYAN}[*] Impostazione permessi e preferenze di sistema...${NC}"
chmod +x ~/.config/labwc/autostart
chmod +x ~/.config/labwc/scripts/*.sh 2>/dev/null

# Applichiamo il nome del tema ufficialmente
gsettings set org.gnome.desktop.interface gtk-theme 'Vanilla_Newbie'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Fix per GTK2 (Thunar e vecchie app)
echo 'gtk-theme-name="Vanilla_Newbie"' > ~/.gtkrc-2.0

# 8. --- APPLICAZIONE FINALE ---
echo -e "------------------------------------------------"
if command -v labwc >/dev/null 2>&1; then
    labwc --reconfigure
    echo -e "${CYAN}[INFO]${NC} LabWC ricaricato."
fi

# Avvio Waybar
if [ -f ~/.config/labwc/scripts/launch-waybar.sh ]; then
    ~/.config/labwc/scripts/launch-waybar.sh &
fi

echo -e "${GREEN}--- ✅ SUCCESSO: Setup Vanilla_Newbie completato! ---${NC}"
echo -e "${MAGENTA}[NOTA]${NC} Ricorda di installare l'estensione Firefox dal README!"