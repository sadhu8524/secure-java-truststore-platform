# Trivy Operator: continuous assessment

Install Trivy Operator using its official Helm chart with pinned version and `examples/trivy/values.yaml`. Trivy Operator watches Kubernetes workloads and creates custom resources such as `VulnerabilityReport`, `ConfigAuditReport`, `RbacAssessmentReport`, and `ExposedSecretReport` (availability varies by release). The operator scans running workload **images and configuration**, not live process memory.

```bash
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm repo update
helm upgrade --install trivy-operator aqua/trivy-operator -n trivy-system --create-namespace -f examples/trivy/values.yaml
bash examples/trivy/commands.sh
trivy config examples/
trivy image --severity HIGH,CRITICAL registry.example.com/platform/java-demo@sha256:REPLACE_DIGEST
trivy k8s --report summary cluster
```

Run Trivy in CI before signing/publishing. Define SLAs by severity, prioritize exploitable vulnerabilities, document exceptions with expiry, and track remediation. Do not treat `ignoreUnfixed: true` as a compliance exemption. Secure the operator's RBAC and scanner cache; review network egress and data retention.
