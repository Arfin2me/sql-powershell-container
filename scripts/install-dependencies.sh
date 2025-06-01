#!/bin/bash
set -e

echo "[+] Installing base dependencies and Microsoft repo..."

# Add Microsoft GPG key and repository once
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/microsoft.list

apt-get update && \
apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    software-properties-common \
    unixodbc-dev \
    wget \
    ca-certificates && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
