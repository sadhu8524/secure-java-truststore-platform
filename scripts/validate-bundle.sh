#!/usr/bin/env bash
set -euo pipefail
namespace="${1:-demo-java}"
kubectl get bundle enterprise-ca-pem -o yaml
kubectl get bundle enterprise-java-truststores -o yaml
kubectl -n "$namespace" get configmap enterprise-ca-pem -o jsonpath='{.data.ca-bundle\.pem}' | openssl crl2pkcs7 -nocrl -certfile /dev/stdin | openssl pkcs7 -print_certs -noout
kubectl -n "$namespace" get secret enterprise-java-truststores -o jsonpath='{.data.truststore\.jks}' | base64 -d > /tmp/enterprise-truststore-$$.jks
trap 'rm -f /tmp/enterprise-truststore-$$.jks' EXIT
TRUSTSTORE_PASSWORD="${TRUSTSTORE_PASSWORD:?Set TRUSTSTORE_PASSWORD}" "$(dirname "$0")/verify-jks.sh" /tmp/enterprise-truststore-$$.jks
