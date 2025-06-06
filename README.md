# SQL Server + PowerShell + dbatools Docker Container

A ready-to-use development environment for automating SQL Server tasks with PowerShell 7 and the [dbatools](https://dbatools.io/) module.

## Features

- **SQL Server 2022** running in a Docker container
- **PowerShell 7** pre-installed
- **dbatools** and **SqlServer** PowerShell modules
- Automatically connects to the SQL instance using credentials from `.env`
- Connection object available as `$SqlInstance` for dbatools commands
- Uses PowerShell cmdlets (no `sqlcmd` binary) for running queries
- Example `connect-success.sql` script demonstrates using the CONNECT statement
  to establish a session
  
## Setup & Usage

### 1. Clone this repository

```bash
git clone https://github.com/Arfin2me/sql-powershell-container.git
cd sql-powershell-container
```

### 2. Configure environment variables

Create a `.env` file based on `.env.example` and set passwords for the SQL login and the PFX certificate bundle:

```
SA_PASSWORD=CreateYourPassword1!
SQL_LOGIN=sa
SQL_PASSWORD=CreateYourPassword1!
PFX_PASSWORD=YourActualPfxPasswordHere
```

### 3. Generate TLS certificates

This container expects three TLS files in the `mssql-certs/` directory: `mssql.key`, `mssql.crt`, and `mssql.pfx`. They enable encrypted connections to SQL Server and the server will not start without them.

Run **one** of the provided scripts to create the files:

**Bash script** (requires `openssl`):
  ```bash
   # Syntax: ./scripts/generate-mssql-selfsigned-cert.sh [CN] [PFX_PASSWORD]
  bash ./scripts/generate-mssql-selfsigned-cert.sh
  ```
  The script accepts an optional password argument. If omitted it reads `PFX_PASSWORD` from the environment (default `ChangeMe123!`). To specify a custom value directly, pass it as the second argument. For example:
  ```bash
  bash ./scripts/generate-mssql-selfsigned-cert.sh localhost "MyPfxPassword!"
  ```
  
- **PowerShell script** (also uses `openssl` to extract the key):
  ```powershell
  pwsh ./generate-mssql-selfsigned-cert.ps1
  ```

The password you use when generating the `.pfx` must match `PFX_PASSWORD` in `.env`.

### 4. Prepare the backups directory

If you plan to take SQL Server backups, create an empty `backups` directory so the compose volume mount succeeds:

```bash
mkdir backups
```

### 5. Build and start the container

```bash
docker-compose up -d --build
```

After the build completes you can enter PowerShell inside the running container:

```bash
docker exec -it sql-dev pwsh
```

### 6. Using the container

The `.env` file provides credentials for both SQL Server and the initial
PowerShell connection. Update the values to whatever login and password you
prefer. The environment variables are consumed by `docker-compose` and by the
PowerShell profile when it automatically connects:

```
SA_PASSWORD=<strong-password-for-sa>
SQL_LOGIN=sa
SQL_PASSWORD=<same-as-sa-or-other>
PFX_PASSWORD=<password-used-when-creating-mssql.pfx>
HOST_PORT=1433
ALLOWED_IPS=192.168.1.10,192.168.1.20  # optional
```

Once the container is running you can connect to the SQL instance from your host
using any SQL tool at `localhost,$HOST_PORT` (defaults to `localhost,1433`).
Remote machines should use the host's IP address instead of `localhost`.
When `ALLOWED_IPS` is specified, only those addresses will be able to connect.

Inside the PowerShell session, the profile stores the live connection object in
`$SqlInstance`. Use this variable with dbatools commands instead of typing the
instance name each time, for example:

```powershell
Get-DbaDatabase -SqlInstance $SqlInstance
```

### Importing a database backup

1. Place your `.bak` file in the `backups/` folder so the container can access it at `/var/opt/mssql/backup`.
2. Open a PowerShell session inside the container:
   ```
   bash docker exec -it sql-dev pwsh
   ```
3. Restore the backup with the helper script:
   ```powershell
   /scripts/import-database.ps1 -BackupFile /var/opt/mssql/backup/YourDatabase.bak -WithReplace
   ```
   This uses dbatools and the credentials from the environment to perform the restore.
### Enabling SQL Server Agent

To run SQL Agent jobs, enable Agent XPs with:

```powershell
/scripts/enable-agent-xps.ps1
```

## Windows users: installing WSL and OpenSSL

The certificate scripts require `openssl`. On Windows the easiest way to get it is via the Windows Subsystem for Linux (WSL).

1. **Install WSL with Ubuntu**
   - Open PowerShell **as Administrator** and run:
     ```powershell
     wsl --install -d Ubuntu
     ```
   - Restart when prompted. After reboot, launch "Ubuntu" from the Start menu to complete the installation.

2. **Install OpenSSL inside WSL**
   ```bash
   sudo apt-get update
   sudo apt-get install -y openssl
   ```

3. **Run the certificate script**
   From the repository directory mounted inside WSL, run:
   ```bash
   bash ./scripts/generate-mssql-selfsigned-cert.sh
   ```

Alternatively, if you have PowerShell 7 and a native OpenSSL installation on Windows (via [winget](https://learn.microsoft.com/windows/package-manager/winget/) or [Chocolatey](https://chocolatey.org/)) you can run the PowerShell script instead.

## Why certificates?

SQL Server is configured in this image to use TLS for encrypted connections. The container looks for the certificate files at startup and refuses to run if they are missing or the password does not match. Using the provided scripts ensures the server has a self-signed certificate and that PowerShell can trust it when connecting.

---
