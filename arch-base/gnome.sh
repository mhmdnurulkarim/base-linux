#!/bin/bash

# Modern GNOME Installation Script for Arch Linux

set -e

print_msg() {
    echo -e "\n\e[1;34m==>\e[1;32m $1 \e[0m"
}

print_msg "Updating system..."
sudo pacman -Syu --noconfirm

print_msg "Installing GNOME and essential tools..."
sudo pacman -S --noconfirm --needed \
    gnome gnome-tweaks \
    xdg-user-dirs-gtk \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-jetbrains-mono ttf-fira-code \
    arc-gtk-theme arc-icon-theme

print_msg "Enabling GDM (Display Manager)..."
sudo systemctl enable gdm

print_msg "Installation complete. Rebooting in 5 seconds..."
sleep 5
reboot
