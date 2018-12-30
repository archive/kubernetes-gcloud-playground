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

fn__create_cluster () {
  gcloud beta container --project "$GCLOUD_PROJECT_ID" clusters create "$GCLOUD_CLUSTER_NAME" --zone "europe-north1-a" --username "admin" --cluster-version "1.10.9-gke.5" --machine-type "g1-small" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --no-enable-cloud-logging --no-enable-cloud-monitoring --enable-ip-alias --network "projects/$GCLOUD_PROJECT_ID/global/networks/default" --subnetwork "projects/$GCLOUD_PROJECT_ID/regions/europe-north1/subnetworks/default" --default-max-pods-per-node "110" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

  gcloud container clusters list
}

fn__get_credentials () {
  gcloud container clusters get-credentials $GCLOUD_CLUSTER_NAME --zone europe-north1-a --project $GCLOUD_PROJECT_ID

  kubectl config use-context $KUBECTL_CONFIG_CONTEXT_NAME
}

fn__build_and_push_dotnetcore_service () {
  gcloud auth configure-docker

  docker-compose -f dotnetcore/docker-compose.yml build
  docker tag dotnetcore-testsvc-app-image gcr.io/$GCLOUD_PROJECT_ID/dotnetcore-testsvc-app-image
  docker push gcr.io/$GCLOUD_PROJECT_ID/dotnetcore-testsvc-app-image:latest
}

fn__dotnetcore_deployment () {
  cat dotnetcore/.kube/deployment.yaml | sed 's/\$GCLOUD_PROJECT_ID'"/$GCLOUD_PROJECT_ID/g" | kubectl apply -f -
  kubectl get pods

  echo ""
  kubectl apply -f dotnetcore/.kube/service.yaml
  kubectl get services
}

fn__build_and_push_nodejs_service () {
  gcloud auth configure-docker

  docker-compose -f nodejs/docker-compose.yml build
  docker tag nodejs-test-svc-app-image gcr.io/$GCLOUD_PROJECT_ID/nodejs-test-svc-app-image
  docker push gcr.io/$GCLOUD_PROJECT_ID/nodejs-test-svc-app-image:latest
}

fn__nodejs_deployment () {
  cat nodejs/.kube/deployment.yaml | sed 's/\$GCLOUD_PROJECT_ID'"/$GCLOUD_PROJECT_ID/g" | kubectl apply -f -
  kubectl get pods
  
  echo ""
  kubectl apply -f nodejs/.kube/service.yaml
  kubectl get services
}

run () {
  #kubectl config get-contexts
  #kubectl config get-clusters

  echo "Current active account:"
  gcloud auth list --filter=status:ACTIVE --format="value(account)"
  echo ""

  set -x
  fn__create_cluster
  fn__get_credentials
  fn__build_and_push_dotnetcore_service
  fn__dotnetcore_deployment
  fn__build_and_push_nodejs_service
  fn__nodejs_deployment
  set +x
}

time run
