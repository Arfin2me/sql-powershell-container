#!/bin/bash
set -e

CERT_DIR="./mssql-certs"
CN_NAME="${1:-localhost}"
DAYS_VALID=730
KEY_NAME="mssql.key"
CRT_NAME="mssql.crt"
PFX_NAME="mssql.pfx"
# Use the provided password argument or fall back to the PFX_PASSWORD
# environment variable. If neither is set, use a sane default.
PFX_PASS="${2:-${PFX_PASSWORD:-ChangeMe123!}}"

mkdir -p "$CERT_DIR"

if [ -f "$CERT_DIR/$PFX_NAME" ]; then
  echo "[!] Certificate already exists at $CERT_DIR/$PFX_NAME. Delete it if you want to regenerate."
  exit 1
fi

echo "[+] Generating self-signed certificate for CN=$CN_NAME..."

# Generate private key
openssl genrsa -out "$CERT_DIR/$KEY_NAME" 2048

# Generate certificate signing request (CSR)
openssl req -new -key "$CERT_DIR/$KEY_NAME" -subj "/CN=$CN_NAME" -out "$CERT_DIR/mssql.csr"

# Generate self-signed certificate
openssl x509 -req -in "$CERT_DIR/mssql.csr" -signkey "$CERT_DIR/$KEY_NAME" -out "$CERT_DIR/$CRT_NAME" -days $DAYS_VALID

# Create PKCS#12 bundle
openssl pkcs12 -export -out "$CERT_DIR/$PFX_NAME" -inkey "$CERT_DIR/$KEY_NAME" -in "$CERT_DIR/$CRT_NAME" -password pass:$PFX_PASS

# Clean up CSR
rm "$CERT_DIR/mssql.csr"
