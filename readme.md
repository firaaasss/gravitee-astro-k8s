# README.md
# Gravitee Kubernetes Demo

This repository deploys the full Gravitee API Management stack into a local Minikube Kubernetes cluster using Helm.

## Requirements
- Minikube
- Helm v3
- kubectl
- bash

## Setup
```bash
cp license-example.key license.key
```

## Start the environment
```bash
./bin/up.sh --deploy gravitee-stack
```

## Stop and clean up
```bash
./bin/down.sh
```

## Access
- Gravitee Console: http://apim.example.com/console
- Credentials: `admin` / `admin`