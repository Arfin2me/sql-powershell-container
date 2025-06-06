param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$CsvFile,
    [Parameter(Mandatory=$true)]
    [string]$Database,
    [Parameter(Mandatory=$true)]
    [string]$Table,
    [string]$Schema = 'dbo',
    [switch]$Truncate,
    [switch]$AutoCreate
)

# Warn if the Flat_Files directory is missing
$flatDir = '/var/opt/mssql/backup/Flat_Files'
if (-not (Test-Path $flatDir)) {
    Write-Warning "Directory '$flatDir' not found. Create it on the host with 'mkdir -p backups/Flat_Files' to make CSV files available."    
}

if (-not (Test-Path $CsvFile)) {
    $file = Split-Path $CsvFile -Leaf
    $searchPaths = @(
        Join-Path -Path '/var/opt/mssql/backup' -ChildPath $file
        Join-Path -Path $flatDir -ChildPath $file
    )
    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            $CsvFile = $path
            break
        }
    }
    if (-not (Test-Path $CsvFile)) {
        throw "CSV file '$CsvFile' not found."
    }
}

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

$importParams = @{
    SqlInstance = $Global:SqlInstance
    Database    = $Database
    Table       = $Table
    Schema      = $Schema
    Path        = $CsvFile
    Truncate    = $Truncate.IsPresent
    ErrorAction = 'Stop'
}
if ($AutoCreate.IsPresent) {
    $importParams.AutoCreateTable = $true
}

Import-DbaCsv @importParams
Write-Host "[✓] Imported $CsvFile into $Database.$Schema.$Table" -ForegroundColor Green
