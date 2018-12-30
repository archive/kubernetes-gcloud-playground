#!/bin/bash

if [ -z "$GCLOUD_PROJECT_ID" ]; then
  echo "Missing value for ENV GCLOUD_PROJECT_ID"
  exit 1
fi  

if [ -z "$GCLOUD_CLUSTER_NAME" ]; then
  echo "Missing value for ENV GCLOUD_CLUSTER_NAME"
  exit 1
fi  

if [ -z "$KUBECTL_CONFIG_CONTEXT_NAME" ]; then
  echo "Missing value for ENV GCLOUD_CLUSTER_NAME"
  exit 1
fi  

delete_cluster () {
  gcloud container clusters delete $GCLOUD_CLUSTER_NAME

  gcloud container clusters list
}

delete_context () {
  kubectl config delete-context $KUBECTL_CONFIG_CONTEXT_NAME
}

run () {
  echo "Current active account:"
  gcloud auth list --filter=status:ACTIVE --format="value(account)"
  echo ""

  set -x
  delete_cluster
  delete_context
  set +x
}

time run