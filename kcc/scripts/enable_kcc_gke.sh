#For existing cluster
expost CLUSTER_NAME='demo-kcc-cluster'
gcloud container clusters update CLUSTER_NAME \
    --update-addons ConfigConnector=ENABLED