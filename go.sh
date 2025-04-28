#!/bin/bash

# One-Installer: Instalasi Go Versi 1.24.0 atau Lebih Tinggi di Ubuntu
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

# Menghapus awalan "go" dari versi, misal dari "go1.24.2" menjadi "1.24.2"
GO_VERSION_NUMBER=${GO_LATEST#go}

# Fungsi untuk membandingkan dua versi
version_greater_equal() {
  # Mengembalikan true jika versi pertama lebih besar atau sama dengan versi kedua
  [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

MIN_VERSION="1.24.0"

echo "Memeriksa apakah versi $GO_VERSION_NUMBER memenuhi syarat minimal $MIN_VERSION..."
if ! version_greater_equal "$GO_VERSION_NUMBER" "$MIN_VERSION"; then
  echo "Versi Go $GO_VERSION_NUMBER tidak memenuhi syarat minimal $MIN_VERSION."
  echo "Instalasi dibatalkan."
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
