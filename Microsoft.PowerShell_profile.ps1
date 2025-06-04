param (
    [string]$CN = "localhost",
    [System.Security.SecureString]$PfxPassword
)

$CertDir = "mssql-certs"
$PfxFile = "$CertDir\mssql.pfx"
$CrtFile = "$CertDir\mssql.crt"

if (-not $PfxPassword) {
    # Prompt interactively and hide input
    $PfxPassword = Read-Host "Enter password for .pfx export" -AsSecureString
}

if (-not (Test-Path $CertDir)) {
    New-Item -Type Directory -Path $CertDir | Out-Null
}

if (Test-Path $PfxFile) {
    Write-Host "[!] Certificate already exists at $PfxFile. Delete it to regenerate." -ForegroundColor Yellow
    exit 0
}

Write-Host "[+] Generating self-signed certificate for CN=$CN ..."

$cert = New-SelfSignedCertificate `
    -DnsName $CN `
    -CertStoreLocation "cert:\CurrentUser\My" `
    -KeyExportPolicy Exportable `
    -NotAfter (Get-Date).AddYears(2) `
    -FriendlyName "SQL Server Self-Signed Cert"

Export-PfxCertificate -Cert $cert -FilePath $PfxFile -Password $PfxPassword
Export-Certificate -Cert $cert -FilePath $CrtFile

Write-Host "[✓] Certificate and key created in '$CertDir'!"
Write-Host "    - mssql.pfx: PKCS#12 bundle (password-protected)"
Write-Host "    - mssql.crt: Certificate file"
Write-Host ""
Write-Host "To regenerate, just delete the existing files and rerun this script."
Write-Host "Example usage: .\generate-mssql-selfsigned-cert.ps1 -CN 'localhost' -PfxPassword (Read-Host 'Password' -AsSecureString)"

