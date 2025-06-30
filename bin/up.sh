#!/bin/bash

set -e

DEPLOY=""

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --deploy)
      DEPLOY="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
done

if [ -z "$DEPLOY" ]; then
  echo "Usage: ./bin/up.sh --deploy gravitee-stack[,feature-x]"
  exit 1
fi

# Start Minikube
minikube start --memory 4096 --cpus 4
minikube addons enable ingress

IFS=',' read -ra STACKS <<< "$DEPLOY"

for STACK in "${STACKS[@]}"; do
  echo "Deploying $STACK..."
  ./stacks/$STACK/main.sh
  echo "$STACK deployed."
done

echo "Run 'minikube tunnel' in a separate terminal if you haven't already."
echo "Access Gravitee at: http://apim.example.com/console"