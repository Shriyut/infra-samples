#Connect to gke cluster

gcloud container clusters get-credentials demo-kcc-cluster --region us-central1 --project emerald-vigil-428902-v5

#For running argo commands you need to install argo cli to your shell environment

curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.5.5/argo-linux-amd64.gz
gunzip argo-linux-amd64.gz
sudo chmod +x argo-linux-amd64
sudo mv ./argo-linux-amd64 /usr/local/bin/argo

#validate the installation by running
argo version

#create namespace for argo
kubectl create ns argo

# run the argo setup script
#modify lines 1273 1327 and 1336 with appropriate images for argocli, argoexec, and workflow controller
#its best practice to keep these images in artifact registry(required for private clusters)
# line no. can change for a diff version of argo

kubectl apply -f argo-setup.yaml -n argo #pre-requisites mentioned below

#to add the argo images in your artifact registry run the below commands
#pre-requisite - docker should be installed in your shell enviroment

docker pull quay.io/argoproj/workflow-controller:v3.5.5
docker pull quay.io/argoproj/argocli:v3.5.5
docker pull quay.io/argoproj/argoexec:v3.5.5
docker pull quay.io/argoproj/argo-events:v1.9.0
docker pull natsio/prometheus-nats-exporter:0.9.1

docker tag quay.io/argoproj/argocli:v3.5.5 us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/argocli:v3.5.5
docker tag quay.io/argoproj/workflow-controller:v3.5.5 us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/workflow-controller:v3.5.5
docker tag quay.io/argoproj/argoexec:v3.5.5 us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/argoexec:v3.5.5
docker tag quay.io/argoproj/argo-events:v1.9.0 us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/argo-events:v1.9.0
docker tag natsio/prometheus-nats-exporter:0.9.1 us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/natsio/prometheus-nats-exporter:0.9.1

docker push us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/natsio/prometheus-nats-exporter:0.9.1
docker push us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/argocli:v3.5.5
docker push us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/workflow-controller:v3.5.5
docker push us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/argoexec:v3.5.5
docker push us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/quay.io/argoproj/argo-events:v1.9.0

#docker image for testing
docker pull docker/whalesay:latest
docker tag docker/whalesay:latest us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/docker/whalesay:latest
docker push us-docker.pkg.dev/GCP_PROJECT_ID/ARTIFACT_REPO_NAME/docker/whalesay:latest


#Once the docker images have been pushed and argo setup script has been installed
#validate the argo server and workflow controller are running fine
kubectl get pods -n argo



#argo-sa@emerald-vigil-428902-v5.iam.gserviceaccount.com
#gcloud iam service-accounts add-iam-policy-binding IAM_SA_NAME@IAM_SA_PROJECT_ID.iam.gserviceaccount.com \
#    --role roles/iam.workloadIdentityUser \
#    --member "serviceAccount:PROJECT_ID.svc.id.goog[NAMESPACE/KSA_NAME]"
gcloud iam service-accounts add-iam-policy-binding argo-sa@emerald-vigil-428902-v5.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:emerald-vigil-428902-v5.svc.id.goog[argo/argo]"


#kubectl annotate serviceaccount KSA_NAME \
#    --namespace NAMESPACE \
#    iam.gke.io/gcp-service-account=IAM_SA_NAME@IAM_SA_PROJECT_ID.iam.gserviceaccount.com
kubectl annotate serviceaccount argo \
    --namespace argo \
    iam.gke.io/gcp-service-account=argo-sa@emerald-vigil-428902-v5.iam.gserviceaccount.com


#Enabling argo ui

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install -n argo nginx-ingress ingress-nginx/ingress-nginx

#Validate the ingress installation using below commands
kubectl get deployment -n argo nginx-ingress-ingress-nginx-controller
kubectl get service -n argo nginx-ingress-ingress-nginx-controller

#Create the ingress controller
kubectl apply -f client-ingress.yaml

# if you get the below error
# internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io"

kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

#get the ingress ip address by running the below command
kubectl get ingresses -n argo

#hit the ip address of the ingress with /argo prefix
# <ip_addr>/argo

#you'll need access token to view the argo ui

kubectl create role demo-role --verb=list,update,get --resource=workflows.argoproj.io -n argo
kubectl create sa demo-sa -n argo
kubectl create rolebinding demo-rb --role=demo-role --serviceaccount=argo:demo-sa -n argo
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: demo-sa.service-account-token
  namespace: argo
  annotations:
    kubernetes.io/service-account.name: demo-sa
type: kubernetes.io/service-account-token
EOF


#get token by running
ARGO_TOKEN="Bearer $(kubectl get secret -n argo jenkins.service-account-token -o=jsonpath='{.data.token}' | base64 --decode)"
ARGO_TOKEN="Bearer $(kubectl get secret -n argo demo-sa.service-account-token -o=jsonpath='{.data.token}' | base64 --decode)"
echo $ARGO_TOKEN

#paste the token in login page of ingress argo ui

#using gcp cloudsdk image

docker pull google/cloud-sdk:latest
docker tag google/cloud-sdk:latest us-central1-docker.pkg.dev/emerald-vigil-428902-v5/demo-images/google/cloud-sdk:latest
docker push us-central1-docker.pkg.dev/emerald-vigil-428902-v5/demo-images/google/cloud-sdk:latest


#bq load --source_format=CSV --location 'us-central1' --project_id emerald-vigil-428902-v5 emerald-vigil-428902-v5:demo_dataset.demo_data gs://deloitte-s-n-a-demo-bkt/demo_data.csv id:STRING,value:STRING,desc:STRING
