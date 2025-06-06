#!/bin/bash
set -e

# Configure IP allowlist if provided
if [ -n "${ALLOWED_IPS}" ]; then
    echo "[+] Applying IP allowlist for SQL Server"
    # Allow localhost traffic
    iptables -A INPUT -i lo -j ACCEPT
    # Allow established connections
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    IFS=',' read -ra ADDR <<< "$ALLOWED_IPS"
    for ip in "${ADDR[@]}"; do
        iptables -A INPUT -p tcp --dport 1433 -s "$ip" -j ACCEPT
    done
    # Drop other incoming traffic on port 1433
    iptables -A INPUT -p tcp --dport 1433 -j DROP
fi

exec /opt/mssql/bin/sqlservr
