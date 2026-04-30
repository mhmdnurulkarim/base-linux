# 🏗️ Arch Linux Installation Guide

Tutorial langkah-demi-langkah untuk melakukan instalasi Arch Linux menggunakan script yang tersedia.

## 1. Persiapan Disk (Live USB)
Pastikan Anda sudah terkoneksi internet (`iwctl` atau `dhcpcd`).

```bash
# Cek drive Anda (misal: /dev/sda atau /dev/nvme0n1)
lsblk

# Partisi disk
cfdisk /dev/sda
```
*Saran partisi minimal:*
- *Partition 1: EFI System (512MB - 1GB)*
- *Partition 2: Linux Filesystem (Sisa storage)*

## 2. Format & Mount
```bash
# Ganti /dev/sda1 dan /dev/sda2 sesuai hasil partisi Anda
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount partitions
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

## 3. Instalasi Base & Chroot
```bash
# Instal paket dasar
pacstrap /mnt base linux linux-firmware git neovim

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Masuk ke sistem baru
arch-chroot /mnt
```

## 4. Jalankan Script Setup
```bash
# Clone repository
git clone https://github.com/mhmdnurulkarim/base-linux.git
cd base-linux/arch-base

# EDIT KONFIGURASI (PENTING!)
# Pastikan variabel DRIVE, USERNAME, dan HOSTNAME sudah sesuai
# Gunakan 'nvim' atau 'vi'
nvim install-uefi.sh

# Jalankan instalasi sistem dasar
chmod +x install-uefi.sh
./install-uefi.sh
```

## 5. Pasca Instalasi (Desktop Environment)
Setelah reboot dan login dengan user baru Anda:
```bash
cd base-linux/arch-base

# Pilih salah satu Desktop Environment
chmod +x gnome.sh kde.sh xfce.sh cinnamon.sh

./gnome.sh  # Contoh instalasi GNOME
```
