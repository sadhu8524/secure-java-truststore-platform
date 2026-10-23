# Release strategy

Use semantic versioning: patch for documentation/fixes, minor for compatible examples/policies, major for breaking CRD, chart or policy behavior. Tag `vX.Y.Z` from protected main after CI, Kubernetes and OpenShift integration tests. Publish a changelog with tested Kubernetes/OpenShift and operator versions, migration notes, SBOM and checksums. Sign release artifacts and verify provenance. Do not claim compatibility with untested versions.
