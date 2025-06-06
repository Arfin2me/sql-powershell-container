param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$CsvFile,
    [Parameter(Mandatory=$true)]
    [string]$Database,
    [Parameter(Mandatory=$true)]
    [string]$Table,
    [string]$Schema = 'dbo',
    [switch]$Truncate
)

if (-not (Test-Path $CsvFile)) {
    throw "CSV file '$CsvFile' not found."
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

Import-DbaCsv -SqlInstance $Global:SqlInstance -Database $Database -Table $Table -Schema $Schema -Path $CsvFile -Truncate:$Truncate.IsPresent
Write-Host "[✓] Imported $CsvFile into $Database.$Schema.$Table" -ForegroundColor Green
