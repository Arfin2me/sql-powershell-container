FROM mcr.microsoft.com/mssql/server:2022-latest
# Ensure we have root privileges for installing packages
 
USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# -- 1. Install system dependencies first (curl, gnupg2) --
RUN rm -rf /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get install -y ca-certificates curl gnupg2 \
    && apt-get clean

# -- 2. Copy certs, scripts, and PowerShell profile --
COPY --chown=10001:0 mssql-certs/ /var/opt/mssql/certs/
COPY --chown=10001:0 scripts/ /scripts/
COPY --chown=10001:0 Microsoft.PowerShell_profile.ps1 /scripts/Microsoft.PowerShell_profile.ps1

# -- 3. Set permissions, run install scripts, and create directories --
RUN mkdir -p /var/opt/mssql/certs \
    && chmod 700 /var/opt/mssql/certs \
    && find /var/opt/mssql/certs -type f -exec chmod 600 {} + \
    && chmod +x /scripts/*.sh \
    && /scripts/install-dependencies.sh \
    && /scripts/install-pwsh.sh \
    && /scripts/install-modules.sh \
    && /scripts/setup-profile.sh \
    && mkdir -p /var/opt/mssql/backup /home/mssql \
    && chown -R 10001:0 /var/opt/mssql/backup /home/mssql

ENV HOME=/home/mssql

# -- 6. Start as root to allow firewall configuration --
USER root

EXPOSE 1433

CMD ["/scripts/start-sql.sh"]
