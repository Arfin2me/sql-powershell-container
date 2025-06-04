param (
    [string]$CN = "localhost",
    [System.Security.SecureString]$PfxPassword
)

$CertDir = "mssql-certs"
$PfxFile = "$CertDir\mssql.pfx"
$CrtFile = "$CertDir\mssql.crt"
$KeyFile = "$CertDir\mssql.key"

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

# Extract private key using OpenSSL if available
$plainPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($PfxPassword)
$plainPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto($plainPtr)
if (Get-Command openssl -ErrorAction SilentlyContinue) {
    $keyContent = & openssl pkcs12 -in $PfxFile -nocerts -nodes -passin "pass:$plainPass"
    Set-Content -Path $KeyFile -Value $keyContent
} else {
    Write-Warning "OpenSSL not found. '$KeyFile' was not created."
}
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($plainPtr)

Write-Host "[✓] Certificate and key created in '$CertDir'!"
Write-Host "    - mssql.pfx: PKCS#12 bundle (password-protected)"
Write-Host "    - mssql.crt: Certificate file"
Write-Host "    - mssql.key: Private key"
Write-Host ""
Write-Host "To regenerate, just delete the existing files and rerun this script."
Write-Host "Example usage: .\generate-mssql-selfsigned-cert.ps1 -CN 'localhost' -PfxPassword (Read-Host 'Password' -AsSecureString)"
