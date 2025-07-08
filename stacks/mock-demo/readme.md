## Creating analytics

```
curl --location 'http://apim.example.com/management/v2/organizations/DEFAULT/environments/DEFAULT/apis/' \
--header 'Authorization: basic YWRtaW46YWRtaW4=' \
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
    ],
    "plans": [
    {
      "definitionVersion": "V4",
      "flows": [
        {
          "id": "1c8c28f5-68d1-4965-8c28-f568d1b9654e",
          "enabled": true,
          "selectors": [
            {
              "type": "HTTP",
              "path": "/",
              "pathOperator": "STARTS_WITH",
              "methods": []
            }
          ],
          "request": [],
          "response": [],
          "subscribe": [],
          "publish": [],
          "connect": [],
          "interact": [],
          "tags": []
        }
      ],
      "id": "efd6d25b-952c-4cff-96d2-5b952cccff05",
      "name": "Keyless",
      "description": "",
      "apiId": "805b8b7e-7723-4912-9b8b-7e7723b912e9",
      "security": {
        "type": "KEY_LESS",
        "configuration": {}
      },
      "mode": "STANDARD",
      "characteristics": [],
      "commentMessage": "",
      "commentRequired": false,
      "createdAt": "2025-07-08T12:57:30.181Z",
      "excludedGroups": [],
      "generalConditions": "",
      "order": 1,
      "publishedAt": "2025-07-08T12:57:33.183Z",
      "status": "PUBLISHED",
      "tags": [],
      "type": "API",
      "updatedAt": "2025-07-08T12:57:33.183Z",
      "validation": "MANUAL"
    }
  ]
}'

```

