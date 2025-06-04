#!/usr/bin/env bats

setup() {
  # Remove any existing cert files
  rm -f mssql-certs/mssql.{pfx,crt,key}
}

teardown() {
  # Clean up generated cert files
  rm -f mssql-certs/mssql.{pfx,crt,key}
}

@test "generate self-signed certificate" {
  run bash scripts/generate-mssql-selfsigned-cert.sh
  [ "$status" -eq 0 ]
  [ -f mssql-certs/mssql.pfx ]
  [ -f mssql-certs/mssql.crt ]
  [ -f mssql-certs/mssql.key ]
}
