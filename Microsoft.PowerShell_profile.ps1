# PowerShell Profile - Auto-connect to SQL on startup

# Only run if all required variables are set
if ($env:SQL_LOGIN -and $env:SQL_PASSWORD) {
    Import-Module dbatools -Force
    Import-Module SqlServer -Force

    $user = $env:SQL_LOGIN
    $pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

    $global:SqlConnectionString = "Server=localhost;TrustServerCertificate=True;User ID=$user;Password=$env:SQL_PASSWORD;"

    try {
        $global:SqlInstance = Connect-DbaInstance -SqlCredential $cred -SqlInstance localhost
        Write-Host "✔️ Connected to SQL Server: $($SqlInstance.Name)" -ForegroundColor Green
    } catch {
        Write-Warning "⚠️ Could not connect to SQL Server: $($_.Exception.Message)"
    }
} else {
    Write-Host "Environment variables for SQL_LOGIN and/or SQL_PASSWORD are missing."
}

