# Contributing

Use a feature branch and a pull request. Explain the threat model and affected Kubernetes/OpenShift versions. Run YAML parsing, `shellcheck` (if available), `trivy config`, and `kubectl apply --dry-run=server` on a test cluster with installed CRDs. Never commit secrets, signing keys, production certificate chains or real truststore passwords. Include policy tests for both allowed and denied examples. Changes to security policies require a security reviewer. Follow the Code of Conduct.
