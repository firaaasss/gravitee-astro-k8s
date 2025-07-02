# README.md
# Gravitee Kubernetes Demo

This repository deploys the full Gravitee API Management stack into a local Minikube Kubernetes cluster using Helm.

## Requirements
- Minikube
- Helm v3
- kubectl
- bash

# Minikube Quick Demo Install

To start your minikube cluster and expose your services with the ingress addon, run the following:

```
minikube start
minikube addons enable ingress
```

## Setup
```bash
Move your license-key-file into the top level directory
```

## Start the environment

To bring up the environment:
Note: in the future you will be able to add multiple feature deployments later on (eg. full-stack, otel, datadog, etc.)

```bash
./bin/up.sh --deploy full-stack
```

## Stop and clean up

To bring down the environment:

```bash
./bin/down.sh
```

## Expose your services

To access your services below, you will need to run a tunnel:

```
sudo minikube tunnel
```

## Access
- Gravitee Console: http://apim.example.com/console
- Credentials: `admin` / `admin`