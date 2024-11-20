## Steps performed in AlloyDB POC

Linking AlloyDB with argo workflow as part of this POC

Steps of argo workflow:

1. Create an AlloyDB instance and import a sample table
2. Export the sample table from AlloyDB to Google Cloud Storage
3. Import the exported file from google cloud storage to BigQuery
4. Create view on the BigQuery table

This document only concerns itself with the AlloyDB setup
> Enable service networking, resource manager, cloud build, alloydb api beforehand \
> Additionally, you can also use gcloud config set project <project_id> command

### Check if there are any active vpc peerings in your network

```
gcloud services vpc-peerings list --network=default
```

If you get an output like below then skip the next step
```
---
network: projects/595623725232/global/networks/default
peering: servicenetworking-googleapis-com
reservedPeeringRanges:
- default-ip-range
service: services/servicenetworking.googleapis.com
```
If no vpc peering is established with the network where AlloyDB resides then you can use the below command to set one up

```
gcloud compute addresses create IP_RANGE_NAME \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=16 \
    --description="VPC private service access" \
    --network=default
```

### Configure service access with allocated IP range

```
gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=default-ip-range \
    --network=default
```
> Value of ranges parameter is the as the name of vpc peering \
> We wont be covering AlloyDB setup here, please refer to the terraform-modules directory for the same


## Create sample data in your AlloyDB instance

Login to AlloyDB studio and run the below command
> CREATE DATABASE guestbook;

Go to AlloyDB studio page again and select the database 'guestbook'

Run the below commands in the editor

```
CREATE TABLE entries (guestName VARCHAR(255),
                      content VARCHAR(255),
                      entryID SERIAL PRIMARY KEY);
INSERT INTO entries (guestName, content) values ('AlexSong', 'I got here!');
INSERT INTO entries (guestName, content) values ('KaiHavertz', 'Me too!');
```

Validate the execution by running the below query

> SELECT * FROM entries;

## Create sample python script to perform the select * query

> pip3 install "google-cloud-alloydb-connector[pg8000]" \
> pip3 install sqlalchemy \
> pip3 install google-cloud-storage



