# Enables SQL Server Agent by turning on the Agent XPs option

# Ensure required modules are loaded
if (-not (Get-Module -Name dbatools -ErrorAction SilentlyContinue)) {
    Import-Module dbatools
}
if (-not (Get-Module -Name SqlServer -ErrorAction SilentlyContinue)) {
    Import-Module SqlServer
}

# Connect if $SqlInstance is not already available
if (-not $Global:SqlInstance) {
    if (-not $env:SQL_LOGIN -or -not $env:SQL_PASSWORD) {
        throw 'SQL_LOGIN and SQL_PASSWORD environment variables are required.'
    }
    $pw = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($env:SQL_LOGIN, $pw)
    $Global:SqlInstance = Connect-DbaInstance -SqlCredential $cred -SqlInstance localhost -TrustServerCertificate
}

$query = @"
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Agent XPs', 1;
RECONFIGURE;
"@

Invoke-DbaQuery -SqlInstance $Global:SqlInstance -Query $query
Write-Host "[✓] Agent XPs enabled." -ForegroundColor Green
