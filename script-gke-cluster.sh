#!/bin/bash

set -x

function raise_error {
  echo "####################################################"
  echo "####################################################"
  echo "####################################################"
  echo "####################################################"
  echo "Failing deployment due to error in: $1"
  echo "####################################################"
  echo "####################################################"
  echo "####################################################"
  echo "####################################################"
  gcloud beta runtime-config configs variables set \
           failure/workstation-waiter \
           failure --config-name workstation-installer-config
}

### Set Zone
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

gcloud config set compute/zone $ZONE

git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

cd continuous-deployment-on-kubernetes

### Create Cluster
gcloud container clusters create valkyrie-dev --num-nodes 2 --machine-type e2-standard-2 --scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"
# gcloud container clusters create-auto valkyrie-dev --region us-central1 --scopes https://www.googleapis.com/auth/source.read_write,cloud-platform

sleep 15

gcloud container clusters get-credentials valkyrie-dev

cd 

# wget https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz
#
# tar zxfv helm-v3.3.4-linux-amd64.tar.gz
#
# cp linux-amd64/helm .

# ./helm repo add jenkins https://charts.jenkins.io
#
# ./helm repo update
# sleep 5
#
# # Copy updated values file from GSP330
# gsutil cp gs://spls/gsp330/values.yaml jenkins/values.yaml
#
# ./helm install cd jenkins/jenkins -f jenkins/values.yaml --wait
# sleep 5
#
# kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins
#
# export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
# kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &
#
# printf "Waiting on Jenkins to come online"
# while [ $(curl -I http://localhost:8080/login | grep -c "HTTP/1.1 200") -ne 1 ]
# do
#   printf "."
#   sleep 5
# done
# echo ""
#
# gcloud beta runtime-config configs variables set \
#           success/workstation-waiter \
#           success --config-name workstation-installer-config
