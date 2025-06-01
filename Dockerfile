FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# Use root user
USER root

# Install dependencies and PowerShell (latest from Microsoft)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    software-properties-common \
    unixodbc-dev \
    wget \
    ca-certificates && \
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg && \
    echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/microsoft.list && \
    apt-get update && \
    apt-get install -y powershell && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dbatools and SqlServer modules
RUN pwsh -Command "Install-Module dbatools -Force -Scope AllUsers"
RUN pwsh -Command "Install-Module SqlServer -Force -Scope AllUsers"

# Create backup directory
RUN mkdir -p /var/opt/mssql/backup

# Copy PowerShell profile initializer
COPY Microsoft.PowerShell_profile.ps1 /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1

# Set correct permissions on profile file
RUN chmod 644 /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1

# Expose SQL Server port (bind to localhost only for security)
EXPOSE 1433

# Start SQL Server
CMD ["/opt/mssql/bin/sqlservr"]
