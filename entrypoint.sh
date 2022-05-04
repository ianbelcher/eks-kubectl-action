#!/bin/sh

set -e

export AWS_ACCESS_KEY_ID="$INPUT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$INPUT_AWS_SECRET_ACCESS_KEY"
export KUBERNETES_VERSION="${INPUT_KUBERNETES_VERSION}"

echo "kubernetes version: ${KUBERNETES_VERSION}"

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl


echo "aws version"

aws --version

echo "Attempting to update kubeconfig for aws"

aws eks --region "$INPUT_AWS_REGION" update-kubeconfig --name "$INPUT_CLUSTER_NAME"
kubectl "$@"