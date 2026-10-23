#!/usr/bin/env bash
set -euo pipefail
kubectl get vulnerabilityreports.aquasecurity.github.io -A
kubectl get configauditreports.aquasecurity.github.io -A
kubectl get rbacassessmentreports.aquasecurity.github.io -A
kubectl get exposedsecretreports.aquasecurity.github.io -A
# Optional local scans:
# trivy image --severity HIGH,CRITICAL registry.example.com/team/java-demo@sha256:<digest>
# trivy k8s --report summary cluster
# trivy config examples/
