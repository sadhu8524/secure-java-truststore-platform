# cert-manager: issuance and renewal

cert-manager reconciles `Certificate` resources, creates/updates target TLS Secrets, and renews before expiry. `Issuer` is namespace-scoped; `ClusterIssuer` is cluster-scoped. Use an enterprise PKI issuer for production, not the lab self-signed root.

```bash
kubectl apply -f examples/cert-manager/namespaces.yaml
./scripts/create-lab-ca.sh
kubectl apply -f examples/cert-manager/issuer.yaml
kubectl apply -f examples/cert-manager/certificate.yaml
kubectl -n trust-system describe certificate java-demo-server
kubectl -n trust-system get secret java-demo-server-tls
```

## ClusterIssuer example

See `examples/cert-manager/clusterissuer.yaml` for an enterprise CA Secret reference. For a CA `ClusterIssuer`, cert-manager expects the signing Secret in the **cluster resource namespace** (typically `cert-manager`, configurable), not an arbitrary application namespace. Do not duplicate a CA private key across namespaces casually.

## Rotation and renewal

`renewBefore` triggers leaf renewal; `privateKey.rotationPolicy: Always` rotates the leaf key on reissuance. CA rotation requires an independent overlapping trust-anchor process. Observe `Certificate` conditions, CertificateRequests, Events, and issuance errors. A CA certificate in `ca.crt` is not guaranteed to include all chain intermediates.
