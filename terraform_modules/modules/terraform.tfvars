project_id                   = "us-gcp-ame-con-ff12d-npd-1"
service_account_disabled     = false
create_ignore_already_exists = true
service_account_name         = "sample-sa-test"
service_account_display_name = "Sample SA"
service_account_description  = "Sample service account created for Huntington Bank POC"
roles                        = [
  "roles/dataflow.developer",
  "roles/dataflow.worker"
]

regions          = ["us-central1", "us-east4"]
key_ring_name    = "keyring05"
crypto_key_name  = "key05"
rotation_period  = "3153600000s"  # 100 years

artifact_registry_repository_id = "sample-repo"
artifact_registry_repository_format = "DOCKER"
artifact_registry_description  = "Artifact Registry repository for storing Docker images (regional)"

bucket_name = "hnb-bkt-sbx"
force_destroy = true
storage_class = "STANDARD"
uniform_bucket_level_access = true
versioning = false

bigtable_instance_name = "sample-instance"
bigtable_cluster_id    = "sample-cluster"
bigtable_min_nodes     = 1
bigtable_max_nodes     = 3
bigtable_cpu_target    = 60
bigtable_table_name = "test-table1"
bigtable_zones = {
  "us-central1" = ["us-central1-a","us-central1-c", "us-central1-f"]
  "us-east4"    = ["us-east4-a", "us-east4-b"]
}

family_third_type = <<EOF
{
  "aggregateType": {
    "max": {},
    "inputType": {
      "int64Type": {
        "encoding": {
          "bigEndianBytes": {}
        }
      }
    }
  }
}
EOF
