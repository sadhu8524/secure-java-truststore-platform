#!/usr/bin/env bash
set -euo pipefail
umask 077
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
openssl req -x509 -newkey rsa:3072 -sha256 -nodes -days 365 \
  -keyout "$work/ca.key" -out "$work/ca.crt" \
  -subj '/CN=secure-java-truststore-platform LAB CA' \
  -addext 'basicConstraints=critical,CA:TRUE' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign'
kubectl -n trust-system create secret tls internal-root-ca \
  --cert="$work/ca.crt" --key="$work/ca.key" --dry-run=client -o yaml | kubectl apply -f -
echo 'LAB CA created. Never use for production.'
