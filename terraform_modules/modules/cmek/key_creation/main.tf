
// check if a lifecycle hook can be added to skip destroy/ check if key already exists then use the same key
// currently everytime a new key needs to be created
# data "google_kms_crypto_key" "existing_crypto_key" {
#   for_each = toset(var.regions)
#   name     = "${var.crypto_key_name}-${var.region_mapping[each.value]}"
#   key_ring = google_kms_key_ring.key_ring[each.key].id
# }

resource "google_kms_key_ring" "key_ring" {

  for_each = toset(var.regions)
  name = "${var.key_ring_name}-${var.region_mapping[each.value]}"
  location = each.value

}

resource "google_kms_crypto_key" "crypto_key" {
  for_each = toset(var.regions)
  name  = "${var.crypto_key_name}-${var.region_mapping[each.value]}"
  key_ring = google_kms_key_ring.key_ring[each.key].id
  rotation_period = var.rotation_period

  labels = {
    env = "sbx"
    created_by = "terraform"
  }

  lifecycle {
    // as per gcp documentation, keys cannot be deleted, testing the destroy step by setting prevent destroy to false
    // keys remains available but all provisioned key versions from terraform are disabled - not recommended
    prevent_destroy = false
  }

}

resource "google_kms_crypto_key_iam_member" "crypto_key_encrypter_decrypter" {
  for_each = toset(var.regions)
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${var.platform_service_account}"
}


// assigning permission on artifact registry service agent to resolve issue while creating repo with custom key
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_kms_crypto_key_iam_member" "artifact_registry_kms" {
  for_each = toset(var.regions)
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}


// adding below block to resolve error while creating bucket with custom key
resource "google_kms_crypto_key_iam_member" "storage_sa_kms" {
  for_each = toset(var.regions)
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
}

// adding the permissions for bigtable service agent
// bigtable service agent is not enabled by default, enabling it through gcloud results in an error
// gcloud beta services identity create --service=bigtable.googleapis.com --project=us-gcp-ame-con-ff12d-npd-1
// above command doesnt work try with below command to enable the service agent
// gcloud beta services identity create --service=bigtableadmin.googleapis.com --project=us-gcp-ame-con-ff12d-npd-1
resource "google_kms_crypto_key_iam_member" "bigtable_sa_kms" {
  for_each = toset(var.regions)
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-bigtable.iam.gserviceaccount.com"
}
