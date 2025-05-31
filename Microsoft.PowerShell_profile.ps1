if (-not (Get-Module -ListAvailable -Name dbatools)) {
    Install-Module dbatools -Scope AllUsers -Force
}
Import-Module dbatools -Force

$user = $env:SQL_LOGIN
$pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

try {
    $global:SqlInstance = Connect-DbaInstance -SqlInstance localhost -SqlCredential $cred -TrustServerCertificate
    Write-Host "✔️ Connected to SQL Server: $($SqlInstance.Name)" -ForegroundColor Green
} catch {
    Write-Warning "⚠️ Could not connect to SQL Server: $($_.Exception.Message)"
}
