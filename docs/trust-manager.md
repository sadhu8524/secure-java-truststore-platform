# trust-manager: trusted CA distribution

`Bundle` is a cluster-scoped resource. Its `sources` read approved CA material and its `target` writes a ConfigMap or Secret in namespaces selected by labels. This repository uses separate Bundles for PEM ConfigMap and Java Secret. **Do not enable all source Secret access unless needed**; configure the controller trust namespace and its RBAC carefully.

## Installing

Use the official trust-manager Helm chart, pinned to a compatible version. Enable Secret targets explicitly (`secretTargets.enabled=true` on chart versions supporting that setting). Java `additionalFormats` support depends on the trust-manager release and requires `passwordSecretRef` for each JKS/PKCS12 format, pointing to a password Secret in the controller trust namespace. Validate with `kubectl explain bundle.spec.target --recursive` and installed CRDs; do not assume old chart keys are stable.

The example password Secret is placed in `trust-system` and **must be populated out-of-band**. Align the Java app's password Secret with the Bundle's password. Never put private keys in Bundle sources. `includeAllKeys` is **not** needed when selecting one named PEM key; use explicit `secret.key` for deterministic CA selection.

```bash
kubectl apply -f examples/trust-manager/bundle.yaml
kubectl apply -f examples/trust-manager/bundle-java.yaml
kubectl get bundle enterprise-ca-pem -o yaml
kubectl -n demo-java get configmap enterprise-ca-pem
kubectl -n demo-java get secret enterprise-java-truststores
```

## Multiple CA certificates

If 20 PEM CA certificates are held as separate keys in one Secret/ConfigMap, use explicit sources for each key (or an audited all-keys selector when supported). A single PEM file containing concatenated CA certificates can be one source key. Ensure **CA certificates only**, not private keys or leaf certs. Verify expected subject/fingerprint inventory and avoid uncontrolled expansion of trusted roots.

## Distribution and restart

Projected ConfigMap/Secret volumes refresh eventually, but `subPath` mounts do not automatically refresh. JVM TLS contexts often cache loaded trust; use a controlled rollout restart or application-specific reload mechanism after truststore updates. Observe reconciliation status and target namespace labels.
