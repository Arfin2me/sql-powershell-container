param(
    [Parameter(Mandatory=$true)]
    [string]$LoginName,
    [Parameter(Mandatory=$true)]
    [string]$LoginPassword,
    [string]$Database = 'master',
    [string[]]$Roles
)

# Ensure modules are loaded
if (-not (Get-Module -Name dbatools -ErrorAction SilentlyContinue)) {
    Import-Module dbatools
}
if (-not (Get-Module -Name SqlServer -ErrorAction SilentlyContinue)) {
    Import-Module SqlServer
}

# Connect if needed
if (-not $Global:SqlInstance) {
    if (-not $env:SQL_LOGIN -or -not $env:SQL_PASSWORD) {
        throw 'SQL_LOGIN and SQL_PASSWORD environment variables are required.'
    }
    $pw = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($env:SQL_LOGIN, $pw)
    $Global:SqlInstance = Connect-DbaInstance -SqlCredential $cred -SqlInstance localhost -TrustServerCertificate
}

$createLogin = @"
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = '$LoginName')
BEGIN
    CREATE LOGIN [$LoginName] WITH PASSWORD=N'$LoginPassword', CHECK_POLICY=OFF;
END
"@
Invoke-DbaQuery -SqlInstance $Global:SqlInstance -Query $createLogin

$createUser = @"
USE [$Database];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '$LoginName')
BEGIN
    CREATE USER [$LoginName] FOR LOGIN [$LoginName];
END
"@
Invoke-DbaQuery -SqlInstance $Global:SqlInstance -Query $createUser

if ($Roles) {
    foreach ($role in $Roles) {
        $roleQuery = "USE [$Database]; EXEC sp_addrolemember N'$role', N'$LoginName';"
        Invoke-DbaQuery -SqlInstance $Global:SqlInstance -Query $roleQuery
    }
}

Write-Host "[✓] Created login and user '$LoginName' in database '$Database'" -ForegroundColor Green
