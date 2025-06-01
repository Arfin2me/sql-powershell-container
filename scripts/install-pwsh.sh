#!/bin/bash
set -e

echo "[+] Installing PowerShell..."

apt-get update && \
apt-get install -y powershell && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

echo "[✓] PowerShell installed."
