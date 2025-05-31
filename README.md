# sql-powershell-container
This is repository for someone who would like to work on SQL DbaTools module in closed environment.  
It allows you to create working SQL instance which makes it possible to work on SQL Management Studio installed on your computer and access instance with credentials set by yourself in .env file.

SQL Server + PowerShell + dbatools Docker Container

A ready-to-use development environment for automating SQL Server tasks using PowerShell 7 and dbatools.

Features

✅ SQL Server 2022 in a Docker container

✅ PowerShell 7 pre-installed

✅ dbatools and SqlServer PowerShell modules

✅ Auto-connect to SQL instance using environment credentials

Setup & Usage

Clone this repository

git clone https://github.com/Arfin2me/sql-powershell-container.git
cd sql-powershell-container

Configure your environmentCreate a .env file based on the .env.example:

SQL_LOGIN=sa
SQL_PASSWORD=YourStrongPassword123

Build and run the container

docker-compose up -d --build

Access the PowerShell shell inside the container

docker exec -it sql-dev pwsh

Notes

Automatically connects to the SQL Server using $env:SQL_LOGIN and $env:SQL_PASSWORD when pwsh starts.

You can now use:

New-DbaDatabase -SqlInstance $SqlInstance -Name 'MyDatabase'

instead of hardcoding instance names.

Uses localhost and TrustServerCertificate=True for simplicity. Avoid using in production without additional security hardening.

Security Disclaimer

The container binds SQL Server to localhost only.

Port 1433 is not exposed to the internet.

Use only in secure environments or with additional protection (e.g. VPN/WireGuard).

Ensure strong passwords are set in your .env file.

License

This project is licensed under the MIT License.

Author

Created by Bartłomiej Kruk with assistance from ChatGPT (GPT-4o).🗕️ Creation date: 2025-05-31
