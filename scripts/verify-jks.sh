#!/usr/bin/env bash
set -euo pipefail
file="${1:?usage: TRUSTSTORE_PASSWORD=... verify-jks.sh <truststore.jks|truststore.p12>}"
: "${TRUSTSTORE_PASSWORD:?Set TRUSTSTORE_PASSWORD}"
case "$file" in *.p12|*.pfx) type=PKCS12;; *) type=JKS;; esac
keytool -list -keystore "$file" -storetype "$type" -storepass "$TRUSTSTORE_PASSWORD"
