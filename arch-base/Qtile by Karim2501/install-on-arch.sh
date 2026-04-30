#!/bin/bash

# Qtile Installation Script for Arch Linux
# Revised for 2024+ standards

set -e

print_msg() {
    echo -e "\n\e[1;34m==>\e[1;32m $1 \e[0m"
}

# 1. Update System
print_msg "Updating system..."
sudo pacman -Syu --noconfirm

# 2. Install Dependencies
print_msg "Installing dependencies..."
sudo pacman -S --noconfirm --needed \
    base-devel wget git \
    rofi feh xorg xorg-xinit xorg-xinput \
    python-psutil \
    qtile zsh alacritty gparted \
    obs-studio code inkscape gimp shotcut

# 3. Install AUR helper (paru)
print_msg "Checking for paru..."
if ! command -v paru &> /dev/null; then
    print_msg "Installing paru..."
    mkdir -p ~/.srcs
    git clone https://aur.archlinux.org/paru.git ~/.srcs/paru
    cd ~/.srcs/paru
    makepkg -si --noconfirm
    cd ~
fi

# 4. Install AUR Packages
print_msg "Installing AUR packages..."
paru -S --noconfirm --needed \
    ttf-dejavu ttf-meslo-nerd-font-powerlevel10k \
    google-chrome telegram-desktop \
    ttf-font-awesome ttf-font-awesome-4 \
    wps-office wps-office-fonts

# 5. Install Oh-My-Zsh (unattended)
print_msg "Checking for Oh-My-Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_msg "Installing Oh-My-Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

print_msg "Qtile dependencies installed successfully!"
