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

print_msg "Memulai instalasi Pop!_OS Post-Install Script..."

# 1. System Preparation
print_msg "Tahap 1: System Preparation (Update & Upgrade)..."
sudo apt update
sudo apt upgrade -y

print_msg "Menginstal dependensi dasar (curl, wget, git, unzip, rar, unrar)..."
sudo apt install -y curl wget git unzip rar unrar

# 2. CLI Tools & Shell
print_msg "Tahap 2: CLI Tools & Shell..."
sudo apt install -y zsh neofetch ranger

print_msg "Mengubah default shell menjadi ZSH untuk user $USER..."
sudo chsh -s $(which zsh) "$USER"

print_msg "Menginstal Oh-My-Zsh (unattended)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

print_msg "Menginstal plugin ZSH (syntax-highlighting, autosuggestions, completions) & Powerlevel10k..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Menggunakan blok if standar agar set -e tidak menghentikan script jika folder sudah ada
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

# Mengunduh font secara diam-diam (-q) agar output terminal tetap bersih
wget -q -O "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
wget -q -O "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
wget -q -O "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
wget -q -O "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

# Memperbarui cache font sistem
fc-cache -fv

print_msg "Mengatur MesloLGS NF sebagai font default di Terminal..."
# Mendapatkan ID profil default dari GNOME Terminal
GNOME_TERMINAL_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

if [ -n "$GNOME_TERMINAL_PROFILE" ]; then
    # Mematikan penggunaan font sistem
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/" use-system-font false
    # Mengatur font custom ke MesloLGS NF ukuran 11
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/" font 'MesloLGS NF 11'
    print_msg "Font terminal berhasil diubah ke MesloLGS NF."
else
    print_msg "Gagal mendeteksi profil GNOME Terminal. Anda mungkin perlu mengatur font secara manual."
fi

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
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Alias
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"

# Composer Global Bin Path
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

# 3. Development Environment
print_msg "Tahap 3: Development Environment..."

print_msg "Menginstal Database (PostgreSQL & MySQL)..."
sudo apt install -y postgresql mysql-server
sudo systemctl enable --now postgresql
sudo systemctl enable --now mysql

print_msg "Menyiapkan role PostgreSQL superuser untuk user $USER..."
# Memakai || true agar script tidak berhenti jika role sudah pernah dibuat
sudo -u postgres createuser -s "$USER" || true

print_msg "Menginstal PHP dan ekstensi esensial untuk Laravel/Web Development..."
# Menambahkan php-gd, php-bcmath, dan php-sqlite3
sudo apt install -y php php-cli php-zip php-mbstring php-xml php-curl php-pgsql php-mysql php-gd php-bcmath php-sqlite3

print_msg "Menginstal Composer secara global..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

print_msg "Menginstal Laravel Installer secara global..."
composer global require laravel/installer

print_msg "Menginstal NVM dan Node.js..."
# Mengunduh dan menginstal NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Memuat NVM ke environment shell saat ini (agar perintah `nvm install` di baris berikutnya dikenali)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

print_msg "Menginstal Node.js versi LTS..."
nvm install --lts

# 4. GUI Applications (via Flatpak)
print_msg "Tahap 4: GUI Applications via Flatpak..."

print_msg "Memastikan instalasi Flatpak dan repositori Flathub..."
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

print_msg "Menyiapkan aplikasi GUI..."

# Daftar Aplikasi Flatpak
# Hapus tanda pagar (#) pada aplikasi yang ingin diinstal
FLATPAK_APPS=(
    # "com.google.AndroidStudio"       # Android Studio
    # "com.anydesk.Anydesk"            # AnyDesk
    # "io.dbeaver.DBeaverCommunity"    # DBeaver
    # "org.telegram.desktop"           # Telegram
    # "io.github.shiftey.Desktop"      # GitHub Desktop
    # "org.gimp.GIMP"                  # GIMP
    # "org.godotengine.Godot"          # Godot Engine
    # "com.google.Chrome"              # Google Chrome
    # "org.inkscape.Inkscape"          # Inkscape
    # "com.obsproject.Studio"          # OBS Studio
    # "org.shotcut.Shotcut"            # Shotcut
    # "org.videolan.VLC"               # VLC
    # "org.libreoffice.LibreOffice"    # LibreOffice
)

if [ ${#FLATPAK_APPS[@]} -eq 0 ]; then
    print_msg "Tidak ada aplikasi Flatpak yang diaktifkan (semua di-comment). Melewati instalasi..."
else
    print_msg "Menginstal aplikasi Flatpak secara bersamaan..."
    sudo flatpak install -y flathub "${FLATPAK_APPS[@]}"
fi

# 5. Wallpapers
print_msg "Tahap 5: Mengunduh Wallpaper..."
if [ -d "$HOME/Pictures/my-wallpaper" ]; then
    print_msg "Folder wallpaper sudah ada, melakukan update..."
    cd "$HOME/Pictures/my-wallpaper" && git pull
else
    print_msg "Cloning wallpaper repository..."
    git clone https://github.com/mhmdnurulkarim/my-wallpaper.git "$HOME/Pictures/my-wallpaper"
fi

# 6. Finishing Touch
print_msg "Tahap 6: Finishing Touch..."
print_msg "Membersihkan cache paket yang sudah tidak digunakan..."
sudo apt autoremove -y
sudo apt autoclean -y

print_msg "Instalasi Selesai! Silakan restart komputer atau log out agar ZSH dan konfigurasi baru bisa aktif."