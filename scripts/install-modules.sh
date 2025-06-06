#!/bin/bash
set -e

echo "[+] Installing PowerShell modules..."

# Ensure module dir exists
mkdir -p /usr/local/share/powershell/Modules

# Install modules
pwsh -Command "Install-Module dbatools -Force -Scope AllUsers"
pwsh -Command "Install-Module SqlServer -Force -Scope AllUsers"

echo "[✓] Modules installed."
