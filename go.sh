#!/bin/bash

# Skrip Installer Go Terbaru - Kompatibel Ubuntu 20.04/22.04/24.04 dan Turunannya
set -e

echo "Memulai instalasi Go versi terbaru untuk Linux AMD64..."
sleep 1

# Mengecek dependensi dasar
echo "Memeriksa dependensi curl dan wget..."
if ! command -v curl &> /dev/null; then
    echo "curl tidak ditemukan. Menginstal curl..."
    sudo apt update
    sudo apt install -y curl
fi

if ! command -v wget &> /dev/null; then
    echo "wget tidak ditemukan. Menginstal wget..."
    sudo apt update
    sudo apt install -y wget
fi

# Mengambil versi terbaru Go dari situs resmi
echo "Mengambil versi Go terbaru..."
LATEST_VERSION=$(curl -s https://go.dev/VERSION?m=text)
GO_TARBALL="${LATEST_VERSION}.linux-amd64.tar.gz"
DOWNLOAD_URL="https://go.dev/dl/${GO_TARBALL}"

echo "Versi terbaru yang ditemukan: ${LATEST_VERSION}"

# Menghapus instalasi Go sebelumnya (jika ada)
echo "Menghapus instalasi Go yang lama (jika ada)..."
sudo rm -rf /usr/local/go

# Mengunduh dan mengekstrak Go terbaru
echo "Mengunduh ${GO_TARBALL}..."
wget "${DOWNLOAD_URL}"

echo "Mengekstrak Go ke /usr/local..."
sudo tar -C /usr/local -xzf "${GO_TARBALL}"

# Membersihkan file tar
echo "Menghapus berkas unduhan..."
rm "${GO_TARBALL}"

# Menambahkan Go ke PATH, jika belum ada
PROFILE_FILE="$HOME/.profile"
GO_PATH_ENTRY="export PATH=\$PATH:/usr/local/go/bin"

if ! grep -Fxq "$GO_PATH_ENTRY" "$PROFILE_FILE"; then
    echo "Menambahkan Go ke PATH di $PROFILE_FILE..."
    echo "$GO_PATH_ENTRY" >> "$PROFILE_FILE"
fi

# Memuat ulang environment PATH
echo "Memuat konfigurasi PATH..."
source "$PROFILE_FILE"

# Memverifikasi hasil instalasi
echo "Memverifikasi instalasi Go..."
go version

echo "Instalasi Go ${LATEST_VERSION} telah berhasil!"
