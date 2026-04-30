# 🚀 Ubuntu / Pop!_OS Setup Guide

Script ini dirancang untuk mengotomatisasi setup environment kerja (productivity & development) pada distro turunan Ubuntu/Debian.

## Langkah Instalasi (Copy-Paste)

Cukup jalankan blok perintah berikut di terminal Anda:

```bash
# 1. Clone repository
git clone https://github.com/mhmdnurulkarim/base-linux.git

# 2. Masuk ke direktori modul
cd base-linux/ubuntu-base

# 3. Berikan izin eksekusi dan jalankan
chmod +x setup.sh
./setup.sh
```

## Fitur Utama:
1. **Shell & Terminal**: Menginstal Zsh, Oh-My-Zsh, Powerlevel10k, dan plugin esensial.
2. **Development Env**: Setup PHP (Laravel ready), Composer, MySQL, PostgreSQL, dan Node.js (via NVM LTS).
3. **Produktivitas**: Instalasi aplikasi GUI populer via Flatpak (Chrome, Telegram, VS Code, dll).
4. **Personalization**: Otomatis mengunduh koleksi wallpaper pribadi ke `~/Pictures/my-wallpaper`.

---
> **Note**: Script akan meminta password `sudo` di beberapa tahap. Pastikan SSH Key Anda sudah terdaftar di GitHub jika ingin fitur download wallpaper berjalan tanpa hambatan.
