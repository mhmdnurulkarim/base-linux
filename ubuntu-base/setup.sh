#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print progress messages clearly
print_msg() {
    echo -e "\n\e[1;34m==>\e[1;32m $1 \e[0m"
}

print_error() {
    echo -e "\n\e[1;31m==> ERROR:\e[1;31m $1 \e[0m"
}

# Ensure script is not run entirely as root, but handles sudo inside
if [ "$EUID" -eq 0 ]; then
    print_error "Tolong jangan jalankan script ini dengan 'sudo'. Script akan meminta akses sudo saat dibutuhkan."
    exit 1
fi

# Pastikan whiptail terinstal untuk antarmuka interaktif
if ! command -v whiptail &> /dev/null; then
    sudo apt update
    sudo apt install -y whiptail
fi

print_msg "Memulai instalasi Ubuntu Post-Install Script..."

# 1. System Preparation
print_msg "Tahap 1: System Preparation..."
sudo apt update
sudo apt upgrade -y

print_msg "Menginstal dependensi dasar..."
sudo apt install -y curl wget git unzip rar unrar build-essential apt-transport-https ca-certificates gnupg htop tmux tree jq

print_msg "Mengecek status instalasi aplikasi..."

# Fungsi untuk mengecek ketersediaan command
check_cmd() {
    command -v "$1" &> /dev/null
}

# Fungsi untuk mengecek ketersediaan flatpak app
check_flatpak() {
    if command -v flatpak &> /dev/null; then
        flatpak list --app --columns=application | grep -q "^$1$"
    else
        return 1
    fi
}

# Helper untuk menentukan ON/OFF dan menambahkan teks (Sudah Terinstal)
get_status_cmd() {
    if check_cmd "$1"; then echo "OFF"; else echo "ON"; fi
}
get_status_flatpak() {
    if check_flatpak "$1"; then echo "OFF"; else echo "ON"; fi
}
get_desc_cmd() {
    if check_cmd "$1"; then echo "$2 (Sudah Terinstal)"; else echo "$2"; fi
}
get_desc_flatpak() {
    if check_flatpak "$1"; then echo "$2 (Sudah Terinstal)"; else echo "$2"; fi
}

APPS=(
    "zsh" "$(get_desc_cmd zsh "ZSH, Oh-My-Zsh, Neovim & Ranger")" "$(get_status_cmd zsh)"
    "opencode-ai" "$(get_desc_cmd opencode-ai "opencode-ai (NPM)")" "$(get_status_cmd opencode-ai)"
    "9router" "$(get_desc_cmd 9router "9router (NPM)")" "$(get_status_cmd 9router)"
    "claude-code" "$(get_desc_cmd claude "Claude Code CLI")" "$(get_status_cmd claude)"
    "skills" "$(get_desc_cmd skills "Skills CLI")" "$(get_status_cmd skills)"
    "postgresql" "$(get_desc_cmd psql "PostgreSQL Database")" "$(get_status_cmd psql)"
    "mysql" "$(get_desc_cmd mysql "MySQL Server")" "$(get_status_cmd mysql)"
    "php" "$(get_desc_cmd php "PHP & Ekstensi (Laravel)")" "$(get_status_cmd php)"
    "composer" "$(get_desc_cmd composer "Composer & Laravel Installer")" "$(get_status_cmd composer)"
    "pm2" "$(get_desc_cmd pm2 "PM2 Process Manager")" "$(get_status_cmd pm2)"
    "docker" "$(get_desc_cmd docker "Docker (Repositori Resmi)")" "$(get_status_cmd docker)"
    
    "android-studio" "$(get_desc_flatpak com.google.AndroidStudio "Android Studio")" "$(get_status_flatpak com.google.AndroidStudio)"
    "anydesk" "$(get_desc_flatpak com.anydesk.Anydesk "AnyDesk")" "$(get_status_flatpak com.anydesk.Anydesk)"
    "dbeaver" "$(get_desc_flatpak io.dbeaver.DBeaverCommunity "DBeaver")" "$(get_status_flatpak io.dbeaver.DBeaverCommunity)"
    "telegram" "$(get_desc_flatpak org.telegram.desktop "Telegram")" "$(get_status_flatpak org.telegram.desktop)"
    "github-desktop" "$(get_desc_flatpak io.github.shiftey.Desktop "GitHub Desktop")" "$(get_status_flatpak io.github.shiftey.Desktop)"
    "gimp" "$(get_desc_flatpak org.gimp.GIMP "GIMP")" "$(get_status_flatpak org.gimp.GIMP)"
    "godot-engine" "$(get_desc_flatpak org.godotengine.Godot "Godot Engine")" "$(get_status_flatpak org.godotengine.Godot)"
    "google-chrome" "$(get_desc_flatpak com.google.Chrome "Google Chrome")" "$(get_status_flatpak com.google.Chrome)"
    "brave-browser" "$(get_desc_flatpak com.brave.Browser "Brave Browser")" "$(get_status_flatpak com.brave.Browser)"
    "inkscape" "$(get_desc_flatpak org.inkscape.Inkscape "Inkscape")" "$(get_status_flatpak org.inkscape.Inkscape)"
    "obs-studio" "$(get_desc_flatpak com.obsproject.Studio "OBS Studio")" "$(get_status_flatpak com.obsproject.Studio)"
    "shotcut" "$(get_desc_flatpak org.shotcut.Shotcut "Shotcut")" "$(get_status_flatpak org.shotcut.Shotcut)"
    "vlc" "$(get_desc_flatpak org.videolan.VLC "VLC")" "$(get_status_flatpak org.videolan.VLC)"
    "libreoffice" "$(get_desc_flatpak org.libreoffice.LibreOffice "LibreOffice")" "$(get_status_flatpak org.libreoffice.LibreOffice)"
    "obsidian" "$(get_desc_flatpak md.obsidian.Obsidian "Obsidian")" "$(get_status_flatpak md.obsidian.Obsidian)"
    "filezilla" "$(get_desc_flatpak org.filezillaproject.Filezilla "FileZilla")" "$(get_status_flatpak org.filezillaproject.Filezilla)"
    "onlyoffice" "$(get_desc_flatpak org.onlyoffice.desktopeditors "OnlyOffice")" "$(get_status_flatpak org.onlyoffice.desktopeditors)"
    "visual-studio-code" "$(get_desc_flatpak com.visualstudio.code "Visual Studio Code")" "$(get_status_flatpak com.visualstudio.code)"
    
    "wallpaper" "Unduh Wallpaper" "ON"
)

# Menyatukan SEMUA aplikasi dalam satu checklist besar
CHOICES=$(whiptail --title "Pilih Aplikasi untuk Diinstal" --checklist \
"Aplikasi yang sudah terinstal otomatis (OFF) untuk mencegah duplikat.\nTekan SPASI untuk mencentang/menghilangkan centang.\nTekan ENTER untuk memulai instalasi:" 24 85 14 \
"${APPS[@]}" \
3>&1 1>&2 2>&3) || true

if [ -z "$CHOICES" ]; then
    print_msg "Tidak ada aplikasi yang dipilih. Skrip selesai."
    exit 0
fi

# ==========================================
# 2. EKSEKUSI: ZSH & Shell
# ==========================================
if [[ $CHOICES == *"zsh"* ]]; then
    print_msg "Menginstal ZSH, Neofetch, Ranger, & Neovim..."
    sudo apt install -y zsh neofetch ranger neovim
    
    print_msg "Mengubah default shell menjadi ZSH untuk user $USER..."
    sudo chsh -s $(which zsh) "$USER" || true

    print_msg "Menginstal Oh-My-Zsh (unattended)..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM}/plugins/zsh-completions"
    fi

    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
    fi

    print_msg "Mengunduh dan menginstal Font MesloLGS NF untuk Powerlevel10k..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    wget -q -O "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    wget -q -O "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    wget -q -O "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    wget -q -O "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

    fc-cache -fv

    print_msg "Mengonfigurasi .zshrc..."
    cat << 'EOF' > "$HOME/.zshrc"
# Startup
neofetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git ubuntu zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

source $ZSH/oh-my-zsh.sh
autoload -U compinit && compinit

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Alias Manajemen Package
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"
alias remove="sudo apt remove"
alias purge="sudo apt purge"
alias autoremove="sudo apt autoremove -y && sudo apt autoclean"

# Alias PostgreSQL & MySQL
alias start_pgsql="sudo systemctl start postgresql"
alias stop_pgsql="sudo systemctl stop postgresql"
alias status_pgsql="sudo systemctl status postgresql"
alias start_mysql="sudo systemctl start mysql"
alias stop_mysql="sudo systemctl stop mysql"
alias status_mysql="sudo systemctl status mysql"

# Git Aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'

# Composer Global Bin Path
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
fi

# ==========================================
# 3. EKSEKUSI: Vibe Code & CLI Apps
# ==========================================
if [[ $CHOICES == *"opencode-ai"* ]] || [[ $CHOICES == *"9router"* ]] || [[ $CHOICES == *"claude-code"* ]] || [[ $CHOICES == *"skills"* ]]; then
    print_msg "Menyiapkan Vibe Code & CLI Apps..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
    else
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    [[ $CHOICES == *"opencode-ai"* ]] && npm i -g opencode-ai
    [[ $CHOICES == *"9router"* ]] && npm i -g 9router
    [[ $CHOICES == *"skills"* ]] && npm i -g skills
    [[ $CHOICES == *"claude-code"* ]] && curl -fsSL https://claude.ai/install.sh | bash
fi

# ==========================================
# 4. EKSEKUSI: Development Environment
# ==========================================
if [[ $CHOICES == *"postgresql"* ]]; then
    print_msg "Menginstal PostgreSQL..."
    sudo apt install -y postgresql
    sudo systemctl enable --now postgresql
    sudo -u postgres createuser -s "$USER" || true
fi

if [[ $CHOICES == *"mysql"* ]]; then
    print_msg "Menginstal MySQL..."
    sudo apt install -y mysql-server
    sudo systemctl enable --now mysql
fi

if [[ $CHOICES == *"php"* ]]; then
    print_msg "Menginstal PHP dan ekstensi esensial..."
    sudo apt install -y php php-cli php-zip php-mbstring php-xml php-curl php-pgsql php-mysql php-gd php-bcmath php-sqlite3
fi

if [[ $CHOICES == *"composer"* ]]; then
    print_msg "Menginstal Composer & Laravel Installer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    composer global require laravel/installer
fi

if [[ $CHOICES == *"pm2"* ]]; then
    print_msg "Menginstal PM2..."
    npm install -g pm2
fi

if [[ $CHOICES == *"docker"* ]]; then
    print_msg "Menginstal Docker dari Repositori Resmi..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    . /etc/os-release
    CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    sudo usermod -aG docker $USER
    print_msg "User ditambahkan ke grup docker."
fi

# ==========================================
# 5. EKSEKUSI: GUI Applications (Flatpak)
# ==========================================
FLATPAK_APPS=""
for app in $CHOICES; do
    app=$(echo $app | sed 's/"//g') # Hapus quote
    case "$app" in
        android-studio) FLATPAK_APPS="$FLATPAK_APPS com.google.AndroidStudio" ;;
        anydesk) FLATPAK_APPS="$FLATPAK_APPS com.anydesk.Anydesk" ;;
        dbeaver) FLATPAK_APPS="$FLATPAK_APPS io.dbeaver.DBeaverCommunity" ;;
        telegram) FLATPAK_APPS="$FLATPAK_APPS org.telegram.desktop" ;;
        github-desktop) FLATPAK_APPS="$FLATPAK_APPS io.github.shiftey.Desktop" ;;
        gimp) FLATPAK_APPS="$FLATPAK_APPS org.gimp.GIMP" ;;
        godot-engine) FLATPAK_APPS="$FLATPAK_APPS org.godotengine.Godot" ;;
        google-chrome) FLATPAK_APPS="$FLATPAK_APPS com.google.Chrome" ;;
        brave-browser) FLATPAK_APPS="$FLATPAK_APPS com.brave.Browser" ;;
        inkscape) FLATPAK_APPS="$FLATPAK_APPS org.inkscape.Inkscape" ;;
        obs-studio) FLATPAK_APPS="$FLATPAK_APPS com.obsproject.Studio" ;;
        shotcut) FLATPAK_APPS="$FLATPAK_APPS org.shotcut.Shotcut" ;;
        vlc) FLATPAK_APPS="$FLATPAK_APPS org.videolan.VLC" ;;
        libreoffice) FLATPAK_APPS="$FLATPAK_APPS org.libreoffice.LibreOffice" ;;
        obsidian) FLATPAK_APPS="$FLATPAK_APPS md.obsidian.Obsidian" ;;
        filezilla) FLATPAK_APPS="$FLATPAK_APPS org.filezillaproject.Filezilla" ;;
        onlyoffice) FLATPAK_APPS="$FLATPAK_APPS org.onlyoffice.desktopeditors" ;;
        visual-studio-code) FLATPAK_APPS="$FLATPAK_APPS com.visualstudio.code" ;;
    esac
done

if [ -n "$FLATPAK_APPS" ]; then
    print_msg "Menyiapkan Flatpak & Menginstal Aplikasi GUI..."
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    print_msg "Menginstal: $FLATPAK_APPS"
    sudo flatpak install -y flathub $FLATPAK_APPS
fi

# ==========================================
# 6. EKSEKUSI: Wallpapers
# ==========================================
if [[ $CHOICES == *"wallpaper"* ]]; then
    print_msg "Mengunduh/Memperbarui Wallpaper..."
    if [ -d "$HOME/Pictures/my-wallpaper" ]; then
        cd "$HOME/Pictures/my-wallpaper" && git pull
    else
        git clone https://github.com/mhmdnurulkarim/my-wallpaper.git "$HOME/Pictures/my-wallpaper"
    fi
fi

# ==========================================
# 7. Finishing Touch
# ==========================================
print_msg "Tahap Terakhir: Membersihkan cache paket..."
sudo apt autoremove -y
sudo apt autoclean -y

whiptail --title "Selesai" --msgbox "Instalasi Selesai! Silakan restart komputer atau log out agar konfigurasi baru (seperti ZSH dan Docker) bisa aktif secara penuh." 10 60
print_msg "Selesai!"