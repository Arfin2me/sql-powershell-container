# Auto-load modules
if (-not (Get-Module -ListAvailable -Name dbatools)) {
    Install-Module dbatools -Force -Scope AllUsers
}
Import-Module dbatools -Force

# Setup credentials
$user = $env:SQL_LOGIN
$pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

# Connect to instance
try {
    $global:SqlInstance = Connect-DbaInstance -SqlInstance "localhost" -SqlCredential $cred -TrustServerCertificate
    Write-Host "✔️ Connected to SQL Server: $($SqlInstance.Name)" -ForegroundColor Green
} catch {
    Write-Warning "⚠️ Could not connect to SQL Server: $($_.Exception.Message)"
}

# ✅ Add sqlcmd to PATH
$env:PATH += ':/opt/mssql-tools/bin'
