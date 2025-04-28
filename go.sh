#!/bin/bash

# Script to install the latest version of Go on Ubuntu
# Author: ChatGPT
# Usage: bash go_installer.sh

set -e

# Print colored text
print_color() {
    COLOR=$1
    TEXT=$2
    echo -e "\033[${COLOR}m${TEXT}\033[0m"
}

print_color "1;32" "====== Go Language Installer for Ubuntu ======"
print_color "1;34" "This script will install the latest version of Go on your Ubuntu system."

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    print_color "1;31" "Please run this script as root or with sudo."
    exit 1
fi

# Update system
print_color "1;33" "Updating package lists..."
apt-get update -y

# Install required packages
print_color "1;33" "Installing required packages..."
apt-get install -y wget tar curl

# Determine latest Go version
print_color "1;33" "Determining latest Go version..."
LATEST_GO_VERSION=$(curl -s https://golang.org/VERSION?m=text | head -n 1)
print_color "1;32" "Latest Go version: ${LATEST_GO_VERSION}"

# Remove any existing Go installation in /usr/local
if [ -d /usr/local/go ]; then
    print_color "1;33" "Removing existing Go installation..."
    rm -rf /usr/local/go
fi

# Download the latest Go package
print_color "1;33" "Downloading Go ${LATEST_GO_VERSION}..."
wget -q --show-progress "https://golang.org/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz

# Extract Go package
print_color "1;33" "Extracting Go package to /usr/local..."
tar -C /usr/local -xzf /tmp/go.tar.gz

# Clean up
print_color "1;33" "Cleaning up..."
rm /tmp/go.tar.gz

# Set up environment variables
print_color "1;33" "Setting up environment variables..."

# Check if GOPATH and Go binary path are already in PATH
PROFILE_FILE="/etc/profile.d/go.sh"

cat > "$PROFILE_FILE" << 'EOF'
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
EOF

chmod +x "$PROFILE_FILE"

# Create the GOPATH directory if it doesn't exist
print_color "1;33" "Creating GOPATH directory structure..."
mkdir -p /etc/skel/go/{bin,pkg,src}

# Update user profiles
print_color "1;33" "Updating user profiles..."
for user_home in /home/*; do
    if [ -d "$user_home" ]; then
        user=$(basename "$user_home")
        mkdir -p "$user_home/go/"{bin,pkg,src}
        chown -R "$user:$user" "$user_home/go"
        print_color "1;34" "Created Go workspace for user: $user"
    fi
done

# Verify installation
print_color "1;33" "Verifying Go installation..."
GO_VERSION=$(/usr/local/go/bin/go version)

print_color "1;32" "==================================================="
print_color "1;32" "Go has been successfully installed!"
print_color "1;32" "Version: $GO_VERSION"
print_color "1;32" "==================================================="
print_color "1;33" "Please run 'source /etc/profile.d/go.sh' or log out and log back in to start using Go."
print_color "1;33" "Your Go workspace is at ~/go"
