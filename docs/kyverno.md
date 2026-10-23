# Kyverno: policy guardrails

Eight `ClusterPolicy` samples under `examples/kyverno` use **Audit** for initial adoption. Validate against the installed Kyverno release (`kyverno apply`, admission tests), then move to **Enforce** after exception handling and rollout testing. Pod-only policies check Pod admission; add controller auto-generation/coverage tests, ephemeral/init-container variants, and namespace exclusions before production enforcement. The signed-image policy contains a deliberate **invalid placeholder key**; it must be replaced.

| Policy | Protects against |
|---|---|
| 01 non-root | UID 0 execution and container-root privilege exposure |
| 02 resource limits | Unbounded CPU/memory consumption and noisy-neighbor impact |
| 03 no privileged | Excessive Linux capabilities and privilege escalation |
| 04 signed images | Unsanctioned or tampered supply-chain artifacts |
| 05 truststore mount | Java demo missing centrally governed CA trust |
| 06 approved registries | Pulls from untrusted registries (does not replace signature checks) |
| 07 metadata | Unowned/unauditable deployments |
| 08 security context | Missing explicit runtime isolation requirements |

```bash
kubectl apply -f examples/kyverno/01-nonroot.yaml
kubectl apply -f examples/kyverno/02-limits.yaml
kubectl get clusterpolicies
kubectl get policyreports -A
```

**Production hardening:** check initContainers and ephemeralContainers, `hostNetwork`, `hostPath`, `hostPID`, seccomp, capability drops, service account tokens, Pod Security Admission and OpenShift SCC. Restrict policy modification to platform security administrators. Configure exceptions through controlled `PolicyException` workflows, with owner and expiration. Image signature verification requires real keyless identity constraints or a trusted Cosign public key and registry permissions.
