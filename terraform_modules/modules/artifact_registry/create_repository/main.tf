resource "google_artifact_registry_repository" "repository" {
  for_each = toset(var.locations)
  location = each.value
  repository_id = "${var.repository_id}-${var.region_mapping[each.value]}"
  format = var.format
  description = var.description
  kms_key_name = var.crypto_key_names[each.value]
  labels = {
    env = "sbx"
    created_by = "terraform"
  }
}

resource "google_artifact_registry_repository_iam_member" "repository_iam" {
  for_each = toset(var.locations)
  repository = google_artifact_registry_repository.repository[each.value].id
  role       = "roles/artifactregistry.repoAdmin"
  member     = "serviceAccount:${var.platform_service_account}"
}
