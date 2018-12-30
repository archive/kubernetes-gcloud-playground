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
  echo "Missing value for ENV KUBECTL_CONFIG_CONTEXT_NAME"
  exit 1
fi  

fn__delete_cluster () {
  gcloud container clusters delete $GCLOUD_CLUSTER_NAME

  gcloud container clusters list
}

fn__delete_context () {
  #not needed? test to see
  #kubectl config delete-context $KUBECTL_CONFIG_CONTEXT_NAME
}

run () {
  echo "Current active account:"
  gcloud auth list --filter=status:ACTIVE --format="value(account)"
  echo ""

  set -x
  fn__delete_cluster
  fn__delete_context
  set +x
}

time run