#!/usr/bin/env bats

setup() {
  # Remove any existing cert files
  rm -f "$BATS_TEST_DIRNAME/../mssql-certs/mssql."{pfx,crt,key}
}

teardown() {
  # Clean up generated cert files
  rm -f "$BATS_TEST_DIRNAME/../mssql-certs/mssql."{pfx,crt,key}
}

@test "generate self-signed certificate" {
  run bash "$BATS_TEST_DIRNAME/../scripts/generate-mssql-selfsigned-cert.sh"
  [ "$status" -eq 0 ]
  [ -f "$BATS_TEST_DIRNAME/../mssql-certs/mssql.pfx" ]
  [ -f "$BATS_TEST_DIRNAME/../mssql-certs/mssql.crt" ]
  [ -f "$BATS_TEST_DIRNAME/../mssql-certs/mssql.key" ]
}
