#For existing cluster
export CLUSTER_NAME='demo-kcc-cluster'
export REGION='us-central1'
gcloud container clusters update CLUSTER_NAME \
    --update-addons ConfigConnector=ENABLED \
    --region REGION

#kcc is not supported for autopilot clusters

