#!/bin/sh

set -euo pipefail
IFS=$(printf ' \n\t')

debug() {
  if [ "${ACTIONS_RUNNER_DEBUG:-}" = "true" ]; then
    echo "DEBUG: :: $*" >&2
  fi
}

export AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"

echo "aws version"

aws --version

echo "Attempting to update kubeconfig for aws"

aws eks --region "${INPUT_AWS_REGION}" update-kubeconfig --name "${INPUT_CLUSTER_NAME}"

debug "Starting kubectl collecting output"
output=$( kubectl "$@" )
debug "${output}"
echo ::set-output name=kubectl-out::"${output}"
