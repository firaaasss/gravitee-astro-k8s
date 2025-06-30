#!/bin/bash

set -e

LICENSE_KEY_FILE="license.key"

if [ ! -f "$LICENSE_KEY_FILE" ]; then
  echo "❌ Missing license.key file. Please copy license-example.key and paste your Gravitee license into it."
  exit 1
fi

LICENSE_KEY=$(cat "$LICENSE_KEY_FILE")
if [ -z "$LICENSE_KEY" ]; then
  echo "❌ The license.key file is empty. Please paste your valid Gravitee license into it." >&2
  sleep 1  # Optional: gives time for the terminal to print
  exit 1
fi

LICENSE_KEY_B64=$(echo "$LICENSE_KEY" | base64 | tr -d '\n')
if [ -z "$LICENSE_KEY_B64" ]; then
  echo "❌ Failed to encode license.key to base64. Please check the contents."
  exit 1
fi

echo "✅ Installing Gravitee Stack..."

helm upgrade --install gravitee-apim graviteeio/apim \
  --namespace gravitee-k8s-demo \
  --create-namespace \
  --set license.key="$LICENSE_KEY_B64" \
  -f "$(cd "$(dirname "$0")" && pwd)/values.yaml"