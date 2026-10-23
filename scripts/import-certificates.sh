#!/usr/bin/env bash
set -euo pipefail
# Local-only import of CA PEM files into a JKS truststore; never import private keys.
: "${TRUSTSTORE_PASSWORD:?Set TRUSTSTORE_PASSWORD}"
out="${1:?usage: import-certificates.sh <output.jks> <ca1.pem> [ca2.pem ...]}"; shift
(( $# > 0 )) || { echo 'No CA certificates supplied' >&2; exit 1; }
for cert in "$@"; do
  openssl x509 -in "$cert" -noout -text | grep -q 'CA:TRUE' || { echo "Not a CA certificate: $cert" >&2; exit 1; }
  alias="$(openssl x509 -in "$cert" -noout -fingerprint -sha256 | cut -d= -f2 | tr -d : | tr '[:upper:]' '[:lower:]')"
  keytool -importcert -noprompt -trustcacerts -alias "$alias" -file "$cert" \
    -keystore "$out" -storetype JKS -storepass "$TRUSTSTORE_PASSWORD"
done
