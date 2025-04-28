#!/bin/bash

# Script untuk menginstal Go versi 1.24.0 di Ubuntu 22.04
# Pastikan dijalankan dengan hak akses sudo/root

set -e

echo "Memulai proses instalasi Go versi 1.24.0..."

# 1. Tentukan versi Go
GO_VERSION="1.24.0"
ARCH="amd64"

# 2. Unduh file tar.gz dari situs resmi Go
echo "Mengunduh Go ${GO_VERSION}..."
wget https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz -O /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz

# 3. Hapus instalasi Go sebelumnya, jika ada
echo "Menghapus instalasi Go sebelumnya, jika ada..."
sudo rm -rf /usr/local/go

# 4. Ekstrak dan instal Go
echo "Mengekstrak dan menginstal Go ${GO_VERSION}..."
sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz

# 5. Menambahkan Go ke PATH
echo "Menambahkan Go ke PATH..."
if ! grep -q "/usr/local/go/bin" ~/.profile; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
fi

# 6. Terapkan perubahan PATH
source ~/.profile

# 7. Verifikasi instalasi
echo "Verifikasi instalasi..."
go version

echo "Instalasi Go ${GO_VERSION} berhasil diselesaikan."
