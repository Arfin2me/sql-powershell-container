param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$BackupFile,
    [switch]$WithReplace
)

if (-not (Test-Path $BackupFile)) {
    throw "Backup file '$BackupFile' not found."
}

# Ensure modules are loaded
if (-not (Get-Module -Name dbatools -ErrorAction SilentlyContinue)) {
    Import-Module dbatools
}
if (-not (Get-Module -Name SqlServer -ErrorAction SilentlyContinue)) {
    Import-Module SqlServer
}

if (-not $Global:SqlInstance) {
    if (-not $env:SQL_LOGIN -or -not $env:SQL_PASSWORD) {
        throw 'SQL_LOGIN and SQL_PASSWORD environment variables are required.'
    }
    $pw = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($env:SQL_LOGIN, $pw)
    $Global:SqlInstance = Connect-DbaInstance -SqlCredential $cred -SqlInstance localhost -TrustServerCertificate
}

Restore-DbaDatabase -SqlInstance $Global:SqlInstance -Path $BackupFile -WithReplace:$WithReplace.IsPresent
Write-Host "[✓] Database imported from $BackupFile" -ForegroundColor Green
