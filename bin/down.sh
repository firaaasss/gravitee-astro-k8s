#!/bin/bash

set -e

RELEASES=(gravitee-apim)

for rel in "${RELEASES[@]}"; do
  helm uninstall $rel --namespace gravitee-k8s-demo || true
done

kubectl delete namespace gravitee-k8s-demo || true
