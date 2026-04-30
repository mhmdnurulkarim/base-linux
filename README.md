# 🐧 Linux Post-Install & Setup Scripts

Kumpulan bash script untuk mengotomatisasi proses instalasi dan setup environment kerja setelah melakukan clean install pada sistem operasi Linux (Arch Linux & Ubuntu/Pop!\_OS).

---

## 📁 Struktur Modul

Repo ini terbagi menjadi dua modul utama:

1. **arch-base**: Untuk instalasi dasar Arch Linux dan Desktop Environment/Window Manager.
2. **ubuntu-base**: Untuk setup produktivitas (Dev Env, Apps, Zsh) pada distro turunan Ubuntu/Debian (Pop!\_OS, Mint, dll).

---

## 🏗️ Modul 1: Setup Arch Linux & Turunannya (Base & DE)

Gunakan modul ini jika Anda baru saja melakukan boot dari Live USB Arch Linux.

### 1. Tahap Persiapan (Manual)

Lakukan langkah-langkah standar Arch Linux berikut:

1. Load keymap jika perlu.
2. Koneksi internet (`iwctl` atau `dhcpcd`).
3. Partisi disk menggunakan `cfdisk` atau `fdisk`.
4. Format partisi (`mkfs.ext4` untuk root, `mkfs.fat -F32` untuk EFI).
5. Mount partisi ke `/mnt` dan `/mnt/boot`.
6. Jalankan pacstrap:
   ```bash
   pacstrap /mnt base linux linux-firmware git neovim
   ```
7. Generate fstab: `genfstab -U /mnt >> /mnt/etc/fstab`
8. Masuk ke environment chroot: `arch-chroot /mnt`

### 2. Jalankan Script Utama

Setelah berada di dalam `arch-chroot`:

```bash
git clone https://github.com/mhmdnurulkarim/base-linux.git
cd base-linux/arch-base
chmod +x install-uefi.sh
./install-uefi.sh  # Gunakan install-mbr.sh jika Legacy BIOS
```

> **Penting**: Edit variabel `DRIVE`, `USERNAME`, dan `HOSTNAME` di dalam script sesuai kebutuhan sebelum dijalankan.

### 3. Instalasi Desktop Environment (Optional)

Setelah reboot dan login ke user baru:

```bash
cd base-linux/arch-base
chmod +x gnome.sh  # Atau kde.sh, xfce.sh, cinnamon.sh
./gnome.sh
```

---

## 🚀 Modul 2: Setup Ubuntu & Turunannya

Gunakan modul ini untuk setup environment kerja (Web Development, Apps) setelah masuk ke desktop Pop!\_OS atau distro Ubuntu lainnya.

### Fitur yang Diinstal:

- **CLI Tools**: Zsh (Oh-My-Zsh), Powerlevel10k, Syntax Highlighting, Neofetch, Ranger.
- **Dev Environment**: PostgreSQL, MySQL, PHP + Extensions, Composer, Node.js (via NVM LTS).
- **GUI Apps (Flatpak)**: Chrome, Telegram, VS Code, Android Studio, GIMP, OBS, dll.
- **Wallpapers**: Otomatis clone wallpaper ke `~/Pictures`.

### Cara Penggunaan:

```bash
cd base-linux/ubuntu-base
chmod +x setup.sh
./setup.sh
```

Script akan meminta password `sudo` saat dibutuhkan. Pastikan Anda sudah memiliki SSH Key yang terdaftar di GitHub jika ingin fitur download wallpaper berjalan lancar.

---

## 🛠️ Kustomisasi

Setiap script memiliki bagian **Configuration** di bagian atas. Anda sangat disarankan untuk memeriksa variabel berikut:

- `USERNAME`: Username default yang akan dibuat/digunakan.
- `DRIVE`: Lokasi disk untuk instalasi GRUB (khusus Arch).
- `FLATPAK_APPS`: Daftar aplikasi yang ingin diinstal via Flatpak.

---

## 🧹 Maintenance (Arch Only)

Jika sistem Arch Anda terasa berantakan dan ingin melakukan reset ke kondisi "Base" (hanya menyisakan paket inti):

```bash
cd base-linux/arch-base
chmod +x reset_base.sh
./reset_base.sh
```

---

## 🤝 Kontribusi & Dukungan

Script ini dikelola secara personal untuk kebutuhan workflow harian. Silakan fork dan sesuaikan dengan kebutuhan Anda sendiri!

**Enjoy your Linux journey!** 🐧✨
