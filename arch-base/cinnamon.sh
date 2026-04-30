#!/bin/bash

# Modern Cinnamon Installation Script for Arch Linux

set -e

print_msg() {
    echo -e "\n\e[1;34m==>\e[1;32m $1 \e[0m"
}

print_msg "Updating system..."
sudo pacman -Syu --noconfirm

print_msg "Installing Cinnamon and essential tools..."
sudo pacman -S --noconfirm --needed \
    cinnamon \
    lightdm lightdm-gtk-greeter \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-jetbrains-mono ttf-fira-code

print_msg "Enabling LightDM (Display Manager)..."
sudo systemctl enable lightdm

print_msg "Installation complete. Rebooting in 5 seconds..."
sleep 5
reboot
