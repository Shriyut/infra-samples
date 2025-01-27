resource "google_service_account" "service_account" {
  account_id = var.service_account_id
  display_name = var.display_name
  description = var.description
  disabled = var.disabled
  create_ignore_already_exists = var.create_ignore_already_exists
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = toset(var.roles)
  project = var.project
  role = each.value
  member = "serviceAccount:${google_service_account.service_account.email}"
  depends_on = [google_service_account.service_account]
}