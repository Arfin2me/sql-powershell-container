FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# Set root user
USER root

# Copy and run modular installation scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

RUN /scripts/install-dependencies.sh
RUN /scripts/install-pwsh.sh
RUN /scripts/install-modules.sh
RUN /scripts/setup-profile.sh
RUN /scripts/install-sqltools.sh

# Create backup directory
RUN mkdir -p /var/opt/mssql/backup

# Copy PowerShell profile initializer
COPY Microsoft.PowerShell_profile.ps1 /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1
RUN chmod 644 /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1

EXPOSE 1433

CMD ["/opt/mssql/bin/sqlservr"]
