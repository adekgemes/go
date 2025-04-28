#!/bin/bash

# One-Installer: Instalasi Go Terbaru di Ubuntu
# Dibuat untuk otomatisasi instalasi Go

set -e

echo "Memeriksa dependensi curl dan wget..."
sudo apt update
sudo apt install -y curl wget tar

echo "Mengambil versi Go terbaru..."
GO_LATEST=$(curl -s https://go.dev/VERSION?m=text)
echo "Versi terbaru yang ditemukan: $GO_LATEST"

if [ -z "$GO_LATEST" ]; then
  echo "Gagal mengambil informasi versi terbaru Go."
  exit 1
fi

echo "Menghapus instalasi Go lama (jika ada)..."
sudo rm -rf /usr/local/go

echo "Mengunduh $GO_LATEST..."
wget https://go.dev/dl/${GO_LATEST}.linux-amd64.tar.gz -O /tmp/${GO_LATEST}.linux-amd64.tar.gz

echo "Mengekstrak Go ke /usr/local..."
sudo tar -C /usr/local -xzf /tmp/${GO_LATEST}.linux-amd64.tar.gz

# Menambahkan Go ke PATH
echo "Menambahkan Go ke PATH..."
if ! grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.profile; then
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
fi

# Muat ulang profil
source ~/.profile

echo "Pembersihan file sementara..."
rm -f /tmp/${GO_LATEST}.linux-amd64.tar.gz

echo "Instalasi Go versi $GO_LATEST telah selesai."
echo "Versi Go saat ini:"
go version
