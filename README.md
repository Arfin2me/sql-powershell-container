SQL Server + PowerShell + dbatools Docker Container

A ready-to-use development environment for automating SQL Server tasks using PowerShell 7 and dbatools.

Features

✅ SQL Server 2022 in a Docker container

✅ PowerShell 7 pre-installed

✅ dbatools and SqlServer PowerShell modules

✅ Auto-connect to SQL instance using environment credentials

Setup & Usage

Clone this repository:

```bash
 git clone https://github.com/Arfin2me/sql-powershell-container.git
 cd sql-powershell-container
```

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
