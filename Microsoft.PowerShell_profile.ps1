[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

if (-not (Get-Module -ListAvailable -Name dbatools)) {
    Install-Module dbatools -Scope AllUsers -Force
}
Import-Module dbatools -Force

$user = $env:SQL_LOGIN
$pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)

$global:SqlConnectionString = "Server=localhost;TrustServerCertificate=True;User ID=$user;Password=$env:SQL_PASSWORD;"

try {
    $user = $env:SQL_LOGIN
    $pass = ConvertTo-SecureString $env:SQL_PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
    $global:SqlInstance = Connect-DbaInstance -SqlInstance 'localhost' -SqlCredential $cred -EncryptConnection:$false
} catch {
    Write-Warning "⚠️ Could not connect to SQL Server: $_"
}
