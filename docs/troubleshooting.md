# Troubleshooting playbook

| Symptom | Diagnosis | Remediation |
|---|---|---|
| Bundle missing | CRD/controller not installed | Check operator Pods and `kubectl get crd bundles.trust.cert-manager.io` |
| Target missing | Namespace selector or Secret target disabled | Check namespace labels, Bundle status, Helm Secret target setting |
| CA source unavailable | Wrong trust namespace, source key or RBAC | Confirm CA Secret location and exact PEM key |
| `Unrecognized field additionalFormats` | trust-manager version/schema mismatch | Upgrade supported operator or adapt to installed CRD |
| `Invalid keystore format` | Wrong file/type or corruption | Compare `keytool -list -storetype JKS/PKCS12` |
| `Keystore was tampered with` | Password mismatch | Check Bundle password Secret and workload password Secret |
| Java `PKIX path building failed` | Missing intermediate/root or wrong hostname | `openssl s_client -showcerts`, inspect store aliases and chain |
| TLS fails after CA update | JVM caches SSLContext/trust manager | Restart deployment or implement explicit reload |
| OpenShift SCC denies Pod | Fixed UID, privilege/capabilities, forbidden volume | Use arbitrary UID, drop ALL, RuntimeDefault and allowed volumes |
| Kyverno denies Pod | Policy/registry/signature mismatch | Inspect admission event and policy report; fix manifest or signing |
| Trivy reports absent | Scanner not enabled, timeout, RBAC, unsupported workload | Check operator logs, CRDs, namespace selection and scan jobs |

```bash
kubectl describe bundle enterprise-java-truststores
kubectl -n trust-system logs deploy/trust-manager
kubectl -n demo-java describe pod -l app.kubernetes.io/name=java-tls-demo
kubectl -n demo-java get events --sort-by=.lastTimestamp
```

Controller deployment names vary by installation; discover with `kubectl get deployments -A | grep trust-manager`.
