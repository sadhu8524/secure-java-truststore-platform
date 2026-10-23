# Enterprise security practices

## Certificate lifecycle

Keep CA signing keys in HSM or external PKI where feasible. Separate root/intermediate CA ownership from workload certificates. Enforce certificate validity and renewal alerts. Rotate trust anchors with old/new overlap, staged rollout, telemetry, and rollback plan. Maintain certificate fingerprints and approval records.

## Secret handling

Encrypt Kubernetes Secrets at rest using KMS where supported; restrict `get/list/watch` with RBAC; audit access. Use External Secrets/Vault rather than plaintext YAML. `Secret` is not inherently encrypted end-to-end. Restrict trust-manager Secret source access and namespace label mutation. Password-bearing truststore artifacts go to Secret targets; public PEM may go to ConfigMaps.

## Java runtime

Never use `-Djavax.net.ssl.trustStorePassword=...` in command-line arguments in production: process arguments may be observable. Set the password via early Java bootstrap from a Secret-backed environment variable (still visible to privileged runtime observers), or a secure in-process provider. `javax.net.ssl.trustStore` and `javax.net.ssl.trustStoreType` may be set in `JAVA_TOOL_OPTIONS`. Java truststore password must match generated store. Use JVM reload strategy on rotation; prefer narrow trust anchors over system-wide trust.

## Admission and supply chain

Apply Kyverno in Audit first, then Enforce with controlled exceptions. Sign images using Cosign, pin by digest, validate signer identity and signature in admission. Generate SBOMs and attach provenance; protect CI signing identities with OIDC and least privilege. Verify GitOps promotion and branch protection.

## Vulnerability management

Trivy Operator reports are detective controls; CI scan gates are preventive controls. Prioritize critical/high exploitable findings, avoid permanent blanket suppressions, and record risk acceptance with owners and expiry. Ensure scanning results flow to central reporting.

## OpenShift

`restricted-v2` SCC typically enforces arbitrary UID range, drops capabilities and requires restricted volume types. Do not hardcode `runAsUser: 1000`; make image directories group-writable where necessary. Use `oc adm policy who-can use scc restricted-v2` to inspect permissions. Routes and ImageStreams are OpenShift-specific; trust-manager Bundle APIs are not.
