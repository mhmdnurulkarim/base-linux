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

print_msg "Menginstal dependensi dasar (curl, wget, git, unzip)..."
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
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM}/plugins/zsh-completions"
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"

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

EOF

# 3. Development Environment
print_msg "Tahap 3: Development Environment..."

print_msg "Menginstal Database (PostgreSQL & MySQL)..."
sudo apt install -y postgresql mysql-server
sudo systemctl enable --now postgresql
sudo systemctl enable --now mysql

print_msg "Menginstal PHP dan ekstensi esensial untuk Laravel/Web Development..."
sudo apt install -y php php-cli php-zip php-mbstring php-xml php-curl php-pgsql php-mysql

print_msg "Menginstal Composer secara global..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

print_msg "Menginstal NVM dan Node.js..."
# Mengunduh dan menginstal NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Memuat NVM ke environment shell saat ini
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

print_msg "Menginstal Node.js versi LTS..."
nvm install --lts

# 4. GUI Applications (via Flatpak)
print_msg "Tahap 4: GUI Applications via Flatpak..."

print_msg "Memastikan instalasi Flatpak dan repositori Flathub..."
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

print_msg "Menginstal aplikasi GUI satu per satu..."

# Daftar Aplikasi dengan Application ID yang valid di Flathub
# CATATAN: Semua aplikasi di bawah ini di-comment (#) secara default.
# Hal ini untuk mencegah aplikasi menjadi ganda (bertumpuk) jika Anda 
# sudah menginstalnya lewat Cosmic Store / Pop!_Shop (versi .deb).
# Silakan hapus tanda pagar (#) hanya untuk aplikasi yang belum Anda miliki 
# dan benar-benar ingin diinstal dari Flatpak.
FLATPAK_APPS=(
    # "com.google.AndroidStudio"       # Android Studio
    # "com.anydesk.Anydesk"            # AnyDesk
    # "io.dbeaver.DBeaverCommunity"    # DBeaver
    # "org.telegram.desktop"           # Telegram
    # "io.github.shiftey.Desktop"      # GitHub Desktop (Community fork)
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
    for app in "${FLATPAK_APPS[@]}"; do
        print_msg "Menginstal $app..."
        sudo flatpak install -y flathub "$app"
    done
fi

# 5. Wallpapers
print_msg "Tahap 5: Mengunduh Wallpaper..."
if [ -d "$HOME/Pictures/my-wallpaper" ]; then
    print_msg "Folder wallpaper sudah ada, melakukan update..."
    cd "$HOME/Pictures/my-wallpaper" && git pull
else
    print_msg "Cloning wallpaper repository..."
    git clone git@github.com:mhmdnurulkarim/my-wallpaper.git "$HOME/Pictures/my-wallpaper"
fi

# 6. Finishing Touch
print_msg "Tahap 6: Finishing Touch..."
print_msg "Membersihkan cache paket yang sudah tidak digunakan..."
sudo apt autoremove -y
sudo apt autoclean -y

print_msg "Instalasi Selesai! Silakan restart komputer atau log out agar ZSH bisa aktif."
