#!/bin/bash

set -e

echo "🚀 Running mock-demo deployment..."

MGMT_URL="http://apim.example.com/management/v2"
AUTH_HEADER="Authorization: Basic $(echo -n 'admin:admin' | base64)"
API_CHECK_ENDPOINT="$MGMT_URL/organizations/DEFAULT/environments/DEFAULT/apis/"

# Wait for APIM Management API to be ready
echo "⏳ Waiting for APIM Management API to become ready..."
MAX_RETRIES=30
RETRY_INTERVAL=5

for ((i=1; i<=MAX_RETRIES; i++)); do
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" --head "$API_CHECK_ENDPOINT" --header "$AUTH_HEADER")
  if [[ "$STATUS_CODE" == "200" || "$STATUS_CODE" == "401" ]]; then
    echo "✅ APIM Management API is up (HTTP $STATUS_CODE)"
    break
  else
    echo "🔁 [$i/$MAX_RETRIES] APIM not ready yet (HTTP $STATUS_CODE), retrying in $RETRY_INTERVAL seconds..."
    sleep $RETRY_INTERVAL
  fi

  if [[ $i -eq $MAX_RETRIES ]]; then
    echo "❌ APIM Management API did not become ready in time."
    exit 1
  fi
done

echo "➡️ Creating mock API via Management API..."

curl -s -o /dev/null -w "%{http_code}" --location "$API_CHECK_ENDPOINT" \
  --header "$AUTH_HEADER" \
  --header 'Content-Type: application/json;charset=UTF-8' \
  --data '{
    "name": "My First API",
    "apiVersion": "1.0.0",
    "definitionVersion": "V4",
    "type": "PROXY",
    "state": "STARTED",
    "description": "Example of creating my first API using the Management API (mAPI)",
    "listeners": [
        {
            "type": "HTTP",
            "paths": [
                {
                    "path": "/myfirstapi"
                }
            ],
            "entrypoints": [
                {
                    "type": "http-proxy"
                }
            ]
        }
    ],
    "endpointGroups": [
        {
            "name": "default-group",
            "type": "http-proxy",
            "endpoints": [
                {
                    "name": "default",
                    "type": "http-proxy",
                    "weight": 1,
                    "inheritConfiguration": false,
                    "configuration": {
                        "target": "https://api.gravitee.io/echo"
                    }
                }
            ]
        }
    ]
}' | grep -q "201" && echo "✅ API created successfully." || echo "❌ Failed to create API."
