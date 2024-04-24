#!/bin/sh

set -euo pipefail
IFS=$(printf ' \n\t')

debug() {
  if [ "${ACTIONS_RUNNER_DEBUG:-}" = "true" ]; then
    echo "DEBUG: :: $*" >&2
  fi
}

if [ -n "${INPUT_AWS_ACCESS_KEY_ID:-}" ]; then
  export AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
fi

if [ -n "${INPUT_AWS_SECRET_ACCESS_KEY:-}" ]; then
  export AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"
fi

if [ -n "${INPUT_AWS_REGION:-}" ]; then
  export AWS_REGION="${INPUT_AWS_REGION}"
fi

if [ -n "${INPUT_KUBERNETES_VERSION:-}" ]; then
  KUBERNETES_VERSION="${INPUT_KUBERNETES_VERSION}"
else
  KUBERNETES_VERSION="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
fi
export KUBERNETES_VERSION

if [ ! -f "kubectl-$KUBERNETES_VERSION" ]; then
  echo "Downloading https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl"
  curl -L "https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl" -o "kubectl-$KUBERNETES_VERSION"
  chmod +x ./kubectl-"$KUBERNETES_VERSION"
fi
cp ./kubectl-"$KUBERNETES_VERSION" /usr/local/bin/kubectl

echo "aws version"

aws --version

echo "Attempting to update kubeconfig for aws"

if [ -n "${INPUT_EKS_ROLE_ARN}" ]; then
  aws eks update-kubeconfig --name "${INPUT_CLUSTER_NAME}" --role-arn "${INPUT_EKS_ROLE_ARN}"
else
  aws eks update-kubeconfig --name "${INPUT_CLUSTER_NAME}"
fi

debug "Starting kubectl collecting output"

if [ -n "${INPUT_STDIN:-}" ]; then
  output=$(kubectl "$@" <"${INPUT_STDIN}")
else
  output=$(kubectl "$@")
fi

debug "${output}"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  delimiter=$(mktemp -u XXXXXX)

  echo "kubectl-out<<${delimiter}" >>$GITHUB_OUTPUT
  echo "${output}" >>$GITHUB_OUTPUT
  echo "${delimiter}" >>$GITHUB_OUTPUT
else
  echo ::set-output name=kubectl-out::"${output}"
fi
