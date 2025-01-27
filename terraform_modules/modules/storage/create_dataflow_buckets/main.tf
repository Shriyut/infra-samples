resource "google_storage_bucket" "buckets" {
  for_each = {
    for combination in flatten([for region in var.regions : [for bucket_type in var.bucket_types : {
      region = region
      bucket_type = bucket_type
    }]]) :
    "${combination.region}-${combination.bucket_type}" => "${var.bucket_name}-${combination.bucket_type}-${var.region_mapping[combination.region]}"
  }
  name = each.value
  location = join("-", [split("-", each.key)[0], split("-", each.key)[1]])

  labels = {
    env = "sbx"
    created_by = "terraform"
  }

  force_destroy = var.force_destroy
  storage_class = var.storage_class

  uniform_bucket_level_access = var.uniform_bucket_level_access

  versioning {
    enabled = var.versioning
  }

  soft_delete_policy {
    // hardcoding to disable soft delete policy for the buckets
    retention_duration_seconds = 0
  }

  encryption {
    default_kms_key_name = var.crypto_key_names[join("-", [split("-", each.key)[0], split("-", each.key)[1]])]
  }

#   provisioner "local-exec" {
#     command = "echo Location: ${split("-", each.key)[1]}"
#   }

}

resource "google_storage_bucket_iam_member" "bucket_iam_binding" {
  for_each = google_storage_bucket.buckets
  bucket = each.value.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.platform_service_account}"
}
