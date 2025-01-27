module "service_account" {
  source = "./service_account/sa_iam_mapping"

  project                     = var.project_id
  disabled                    = var.service_account_disabled
  create_ignore_already_exists = var.create_ignore_already_exists
  service_account_id          = var.service_account_name
  display_name                = var.service_account_display_name
  description                 = var.service_account_description
  roles                       = var.roles
}

module "key_creation" {
  source = "./cmek/key_creation"

  project_id      = var.project_id
  regions          = var.regions
  key_ring_name    = var.key_ring_name
  crypto_key_name  = var.crypto_key_name
  rotation_period  = var.rotation_period
  region_mapping = local.region_mapping
  platform_service_account = module.service_account.service_account_email

  depends_on = [module.service_account]
}

module "artifact_registry" {
  source = "./artifact_registry/create_repository"

  project_id   = var.project_id
  locations    = var.regions
  repository_id = var.artifact_registry_repository_id
  format = var.artifact_registry_repository_format
  description  = var.artifact_registry_description
  region_mapping = local.region_mapping
  crypto_key_names = module.key_creation.crypto_key_names
  platform_service_account = module.service_account.service_account_email

  depends_on = [module.key_creation]
}

module "create_dataflow_buckets" {
  source = "./storage/create_dataflow_buckets"
  project_id = var.project_id
  regions = var.regions
  bucket_name = var.bucket_name
  force_destroy = var.force_destroy
  storage_class = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  versioning = var.versioning
  region_mapping = local.region_mapping
  bucket_types = local.bucket_types
  platform_service_account = module.service_account.service_account_email
  crypto_key_names = module.key_creation.crypto_key_names

  depends_on = [module.key_creation]
}

module "provision_instance_and_table" {
  source = "./bigtable/provision_instance_and_table"

  project_id     = var.project_id
  regions        = var.regions
  instance_name  = var.bigtable_instance_name
  cluster_id     = var.bigtable_cluster_id
  cpu_target     = var.bigtable_cpu_target
  max_nodes      = var.bigtable_max_nodes
  min_nodes      = var.bigtable_min_nodes
  table_name     = var.bigtable_table_name
  family_third_type = var.family_third_type
  zones          = var.bigtable_zones
  region_mapping = local.region_mapping
  platform_service_account = module.service_account.service_account_email
  crypto_key_names = module.key_creation.crypto_key_names
  zone_mapping = local.zone_mapping

  depends_on = [module.key_creation]
}

# output "crypto_key_namess" {
#   value = module.key_creation.crypto_key_names
# }