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

Configure your environment. Create a .env file based on the .env.example:

SA_PASSWORD=CreateYourPassword1!
SQL_LOGIN=sa
SQL_PASSWORD=CreateYourPassword1!
PFX_PASSWORD=YourActualPfxPasswordHere

### Certificate Setup
Run `./scripts/generate-mssql-selfsigned-cert.sh` or `pwsh ./generate-mssql-selfsigned-cert.ps1` to create TLS certificates.
The generated `mssql.key`, `mssql.crt`, and `mssql.pfx` files must stay in `mssql-certs/` and the password should match `PFX_PASSWORD` in your `.env`.

If you plan to take SQL Server backups, create an empty `backups` directory so the compose volume mount succeeds:

```
mkdir backups
```

Build and run the container

docker-compose up -d --build

Access the PowerShell shell inside the container

docker exec -it sql-dev pwsh

Notes

Automatically connects to the SQL Server using $env:SQL_LOGIN and $env:SQL_PASSWORD when pwsh starts.

You can now use:

New-DbaDatabase -SqlInstance $SqlInstance -Name 'MyDatabase'

instead of hardcoding instance names.

Use in your Powershell to import databases:

docker cp ".\DATABASE.bak" sql-docker-pwsh-final-sql-dev-1:/var/opt/mssql/backup/MyDatabase.bak

".\DATABASE.bak" means that the PowerShell will choose the file from currently targeted location, make sure you are at the correct folder with .bak file.

It will overwrite the file at /var/opt/mssql/backup/MyDatabase.bak if it already exists.

Then inside of Container powershell:
Restore-DbaDatabase -SqlInstance $SqlInstance -Path "/var/opt/mssql/backup/MyDatabase.bak" -UseDestinationDefaultDirectories -WithReplace

Uses localhost and TrustServerCertificate=True for simplicity. Avoid using in production without additional security hardening.

Security Disclaimer

The container binds SQL Server to localhost only.
Therefore, to login to the instance as user you need to download MSSQL extension in Visual Studio Code and login to localhost,1433 server.
Port 1433 is not exposed to the internet.

Use only in secure environments or with additional protection (e.g. VPN/WireGuard).

Ensure strong passwords are set in your .env file.

License

This project is licensed under the MIT License.

Author

Created by Bartłomiej Kruk with assistance from ChatGPT (GPT-4o).🗕️ Creation date: 2025-05-31
