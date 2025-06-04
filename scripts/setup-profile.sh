#!/bin/bash
set -e

echo "[+] Setting up PowerShell profile..."

# Export PSModulePath for shell context (won't affect pwsh sessions, but helps for debugging)
export PSModulePath="/usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules:$PSModulePath"

if [ -f /scripts/Microsoft.PowerShell_profile.ps1 ]; then
  mkdir -p /opt/microsoft/powershell/7
  cp /scripts/Microsoft.PowerShell_profile.ps1 /opt/microsoft/powershell/7/
  chmod 644 /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1
  echo "[✓] PowerShell profile set."
else
  echo "[-] Profile script not found!"
  exit 1
fi
