FROM mcr.microsoft.com/mssql/server:2022-latest

ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

USER root

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    software-properties-common \
    unixodbc-dev \
    wget \
    ca-certificates \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/microsoft.list' \
    && apt-get update \
    && apt-get install -y powershell \
    && rm microsoft.gpg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pwsh -Command "Install-Module dbatools -Force -Scope AllUsers"
RUN pwsh -Command "Install-Module SqlServer -Force -Scope AllUsers"

COPY Microsoft.PowerShell_profile.ps1 /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1

EXPOSE 1433

CMD ["/opt/mssql/bin/sqlservr"]