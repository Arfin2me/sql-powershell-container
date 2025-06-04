FROM mcr.microsoft.com/mssql/server:2022-latest

# Ensure we have root privileges for installing packages
USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# -- 1. Install system dependencies first (curl, gnupg2, nodejs) --
RUN rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get update \
    && apt-get install -y curl gnupg2 ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# -- 2. Copy certs and set permissions --
COPY mssql-certs/ /var/opt/mssql/certs/
RUN chown -R 10001:0 /var/opt/mssql
RUN chown -R 10001:0 /var/opt/mssql/certs && \
    chmod 700 /var/opt/mssql/certs && \
    chmod 600 /var/opt/mssql/certs/*

# -- 3. Copy scripts and PowerShell profile --
COPY scripts/ /scripts/
COPY Microsoft.PowerShell_profile.ps1 /scripts/Microsoft.PowerShell_profile.ps1

# -- 4. Make scripts executable and run install scripts --
RUN chmod +x /scripts/*.sh \
    && /scripts/install-dependencies.sh \
