#!/bin/sh

export AWS_ACCESS_KEY_ID="$INPUT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$INPUT_AWS_SECRET_ACCESS_KEY"

aws eks --region "$INPUT_AWS_REGION" update-kubeconfig --name "$INPUT_CLUSTER_NAME"
kubectl "$@"