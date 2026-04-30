#!/bin/bash

# Arch Linux System Reset Script
# This script marks core packages as explicit and removes everything else.
# Revised for 2024+ standards

set -e

print_msg() {
    echo -e "\n\e[1;34m==>\e[1;32m $1 \e[0m"
}

print_msg "Marking all packages as dependencies..."
sudo pacman -D --asdeps $(pacman -Qqe)

print_msg "Marking core packages as explicit..."
# Core packages that should never be removed
CORE_PACKAGES=(
    base base-devel linux linux-firmware 
    git neovim sudo reflector networkmanager 
    grub efibootmgr os-prober
    bluez bluez-utils
    pipewire pipewire-pulse
    xorg-server xorg-xinit
)

sudo pacman -D --asexplicit "${CORE_PACKAGES[@]}"

print_msg "Removing orphan packages (cleaning system)..."
ORPHANS=$(pacman -Qtdq)
if [ -n "$ORPHANS" ]; then
    sudo pacman -Rns $ORPHANS --noconfirm
else
    print_msg "No orphan packages found."
fi

print_msg "System reset complete. Rebooting in 5 seconds..."
sleep 5
reboot
