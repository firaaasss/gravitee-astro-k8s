#!/bin/bash

set -e

LICENSE_KEY_FILE="license.key"

echo ""
echo "########################################"
echo "# 🔐 Gravitee License Setup"
echo "########################################"
echo ""

if [ ! -f "$LICENSE_KEY_FILE" ]; then
  echo "❌ Missing license.key file. Please copy your license file into the top level directory (eg. license.key)."
  exit 1
fi

LICENSE_KEY=$(cat "$LICENSE_KEY_FILE")
if [ -z "$LICENSE_KEY" ]; then
  echo "❌ The license.key file is empty. Please paste your valid Gravitee license into it." >&2
  exit 1
fi

echo "✅ license.key file found and non-empty."
echo "➡️  Encoding license key to base64..."
export GRAVITEESOURCE_LICENSE_B64="$(cat "$LICENSE_KEY_FILE" | base64)"

if [ -z "$GRAVITEESOURCE_LICENSE_B64" ]; then
  echo "❌ Failed to encode license.key to base64. Please check the file content."
  exit 1
fi

echo "✅ License key successfully base64-encoded."
echo ""

echo "########################################"
echo "# 🚀 Installing Gravitee Stack via Helm"
echo "########################################"

helm upgrade --install gravitee-apim graviteeio/apim \
  --namespace gravitee-k8s-demo \
  --create-namespace \
  --set license.key="$GRAVITEESOURCE_LICENSE_B64" \
  -f "$(cd "$(dirname "$0")" && pwd)/values.yaml"

echo ""
echo "✅ Helm installation complete."
