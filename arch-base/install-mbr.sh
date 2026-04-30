#!/bin/bash

# Modern Arch Linux MBR/Legacy Post-Installation Script
# Revised for 2024+ standards

set -e

# --- Configuration ---
HOSTNAME="Arch"
USERNAME="karim"
TIMEZONE="Asia/Jakarta"
LOCALE="en_US.UTF-8"
# Note: Check your drive with 'lsblk' before running.
# For MBR, this is usually /dev/sda, /dev/sdb, etc.
DRIVE="/dev/sda" 

# --- Functions ---
print_msg() {
    echo -e "\n\e[1;34m==>\e[1;32m $1 \e[0m"
}

# 1. Pacman Optimization
print_msg "Optimizing Pacman (Parallel Downloads)..."
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/ParallelDownloads/a ILoveCandy' /etc/pacman.conf

# 2. System Update
print_msg "Updating system..."
pacman -Syu --noconfirm

# 3. Time & Localization
print_msg "Setting up time and localization..."
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

echo "$LOCALE UTF-8" > /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# 4. Network & Hostname
print_msg "Setting up network and hostname..."
echo "$HOSTNAME" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
EOF

# 5. Core Packages Installation
print_msg "Installing core packages (Pipewire, Ucode, Firmware, etc.)..."
# Detecting CPU for microcode
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
UCODE=""
if [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    UCODE="intel-ucode"
elif [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
    UCODE="amd-ucode"
fi

pacman -S --noconfirm --needed \
    base-devel linux-headers $UCODE \
    grub networkmanager network-manager-applet \
    bluez bluez-utils cups openssh reflector \
    pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber \
    acpi acpid acpi_call os-prober ntfs-3g \
    gvfs gvfs-mtp bash-completion \
    terminus-font ttf-dejavu ttf-liberation \
    xorg-server xorg-xinit xorg-xinput \
    neovim wget curl git htop ranger vlc firefox

# 6. GRUB Configuration
print_msg "Configuring GRUB..."
# Enable os-prober for dual boot support
sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

grub-install --target=i386-pc $DRIVE
grub-mkconfig -o /boot/grub/grub.cfg

# 7. Services Enable
print_msg "Enabling services..."
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable sshd
systemctl enable acpid
systemctl enable reflector.timer

# 8. User Management
print_msg "Setting up user: $USERNAME..."
echo "root:password" | chpasswd
if ! id "$USERNAME" &>/dev/null; then
    useradd -m -G wheel "$USERNAME"
fi
echo "$USERNAME:password" | chpasswd
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$USERNAME

print_msg "Revisi Selesai! Silakan 'exit', 'umount -a', dan 'reboot'."

