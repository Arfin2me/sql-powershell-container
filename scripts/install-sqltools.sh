#!/bin/bash
set -e

echo "[+] Installing SQL tools..."

apt-get update && \
ACCEPT_EULA=Y apt-get install -y mssql-tools msodbcsql17 unixodbc-dev && \
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.profile

echo "[✓] SQL tools installed."
