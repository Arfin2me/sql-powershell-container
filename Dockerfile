FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# Set root user
USER root

# Copy scripts and PowerShell profile
COPY scripts/ /scripts/
COPY Microsoft.PowerShell_profile.ps1 /scripts/Microsoft.PowerShell_profile.ps1

# Make all scripts executable and run them in fewer layers
RUN chmod +x /scripts/*.sh && \
    /scripts/install-dependencies.sh && \
    /scripts/install-pwsh.sh && \
    /scripts/install-modules.sh && \
    /scripts/setup-profile.sh && \
    /scripts/install-sqltools.sh

# Create backup directory
RUN mkdir -p /var/opt/mssql/backup

EXPOSE 1433

CMD ["/opt/mssql/bin/sqlservr"]
