#!/bin/bash

set -e
echo "[+] Installing SQL tools..."

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' > /etc/profile.d/sqltools.sh && \
    chmod +x /etc/profile.d/sqltools.sh && \
    ln -sf /opt/mssql-tools/bin/sqlcmd /usr/local/bin/sqlcmd && \
    ln -sf /opt/mssql-tools/bin/bcp /usr/local/bin/bcp && \
    ln -sf /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd && \
    ln -sf /opt/mssql-tools/bin/bcp /usr/bin/bcp

echo "[✓] SQL tools installed."
