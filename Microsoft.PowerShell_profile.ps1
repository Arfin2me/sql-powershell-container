# PowerShell Profile - Auto-connect to SQL on startup

# Only run if all required variables are set
if ($env:SQL_LOGIN -and $env:SQL_PASSWORD) {
    # Import modules only if they're not already loaded. Load dbatools first so
    # its version of Microsoft.Data.SqlClient is available before SqlServer
    if (-not (Get-Module -Name dbatools)) {
        Import-Module dbatools -ErrorAction SilentlyContinue
    }
    if (-not (Get-Module -Name SqlServer)) {
        Import-Module SqlServer -ErrorAction SilentlyContinue
    }

    $user = $env:SQL_LOGIN
    $pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

    $global:SqlConnectionString = "Server=localhost;TrustServerCertificate=True;User ID=$user;Password=$env:SQL_PASSWORD;"

    try {
        $global:SqlInstance = Connect-DbaInstance -SqlCredential $cred -SqlInstance localhost -TrustServerCertificate
        Write-Host "✔️ Connected to SQL Server: $($SqlInstance.Name)" -ForegroundColor Green
    } catch {
        Write-Warning "⚠️ Could not connect to SQL Server: $($_.Exception.Message)"
    }
} else {
    Write-Host "Environment variables for SQL_LOGIN and/or SQL_PASSWORD are missing."
}
