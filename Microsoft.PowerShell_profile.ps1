# Add SQL tools to PATH
$env:PATH += ':/opt/mssql-tools/bin'

# Ensure dbatools is installed and imported
if (-not (Get-Module -ListAvailable -Name dbatools)) {
    Install-Module dbatools -Scope AllUsers -Force
}
Import-Module dbatools -Force

# Get SQL credentials from environment variables
$user = $env:SQL_LOGIN
$pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

# Define connection string using login and password
$global:SqlConnectionString = "Server=localhost;TrustServerCertificate=True;User ID=$user;Password=$env:SQL_PASSWORD;"

# Attempt connection
try {
    $global:SqlInstance = Connect-DbaInstance -SqlCredential $cred -SqlInstance localhost
    Write-Host "✔️ Connected to SQL Server: $($SqlInstance.Name)" -ForegroundColor Green
} catch {
    Write-Warning "⚠️ Could not connect to SQL Server: $($_.Exception.Message)"
}

