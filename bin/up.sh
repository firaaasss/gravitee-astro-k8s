#!/bin/bash
set -e

DEPLOY=""

########################################
# 🛠️  Parse CLI args
########################################
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --deploy)
      DEPLOY="$2"
      shift 2
      ;;
    *)
      echo "❌ Unknown parameter: $1"
      echo "Usage: ./bin/up.sh --deploy gravitee-stack[,feature-x]"
      exit 1
      ;;
  esac
done

if [ -z "$DEPLOY" ]; then
  echo "❌ No stack specified."
  echo "Usage: ./bin/up.sh --deploy gravitee-stack[,feature-x]"
  exit 1
fi

########################################
# 🧪 Cluster Check
########################################
echo ""
echo "########################################"
echo "# 🔍 Validating Kubernetes Environment"
echo "########################################"

if ! kubectl version --client > /dev/null 2>&1 || ! kubectl get nodes > /dev/null 2>&1; then
  echo "❌ kubectl is not connected to a cluster. Please start Minikube manually."
  exit 1
fi

if ! kubectl get pods -n kube-system | grep -q ingress-nginx; then
  echo "⚠️  Ingress appears to not be running. Did you enable it with: minikube addons enable ingress ?"
fi

########################################
# 🚀 Deploy Requested Stack(s)
########################################
IFS=',' read -ra STACKS <<< "$DEPLOY"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

for STACK in "${STACKS[@]}"; do
  STACK_SCRIPT="$SCRIPT_DIR/stacks/$STACK/main.sh"
  if [ -f "$STACK_SCRIPT" ]; then
    echo ""
    echo "########################################"
    echo "# 📦 Deploying Stack: $STACK"
    echo "########################################"
    bash "$STACK_SCRIPT"
  else
    echo "❌ Stack script not found: $STACK_SCRIPT"
    exit 1
  fi
done

########################################
# ⏳ Wait for all pods to be healthy
########################################
echo ""
echo "Waiting for all pods in 'gravitee-k8s-demo' namespace to become ready..."

kubectl wait --for=condition=Ready pods --all --timeout=300s -n gravitee-k8s-demo

echo ""
echo "✅ All pods are ready."

########################################
# 🧭 Final Instructions
########################################
echo ""
echo "🚪 Run 'minikube tunnel' in a separate terminal if you haven't already."
echo "🌐 Access Gravitee Console at: http://apim.example.com/console"

exit 0