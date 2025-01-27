variable "project_id" {
  description = "The project ID to deploy resources"
  type        = string
}

variable "service_account_disabled" {
  description = "Whether the service account is disabled"
  type        = bool
  default     = false
}

variable "create_ignore_already_exists" {
  description = "Whether to ignore creation if the service account already exists"
  type        = bool
  default     = false
}

variable "service_account_name" {
  description = "The name of the service account"
  type        = string
}

variable "service_account_display_name" {
  description = "The display name of the service account"
  type        = string
}

variable "service_account_description" {
  description = "The description of the service account"
  type        = string
}

variable "roles" {
  description = "A list of roles to assign to the service account"
  type        = list(string)
}

variable "regions" {
  description = "List of regions"
  type        = list(string)
}

variable "key_ring_name" {
  description = "Name of the KMS key ring"
  type        = string
}

variable "crypto_key_name" {
  description = "Name of the KMS crypto key"
  type        = string
}

variable "rotation_period" {
  description = "Rotation period for the KMS crypto key"
  type        = string
}

variable "artifact_registry_repository_id" {
  description = "The ID of the Artifact Registry repository."
  type        = string
}

variable "artifact_registry_repository_format" {
  description = "The format of the Artifact Registry repository (e.g., DOCKER, MAVEN, NPM)."
  type        = string
}

variable "artifact_registry_description" {
  description = "The description of the Artifact Registry repository."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "The name of the Dataflow bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the Dataflow bucket."
  type        = bool
}

variable "storage_class" {
  description = "The storage class of the Dataflow bucket."
  type        = string
}

variable "uniform_bucket_level_access" {
  description = "Whether to enable uniform bucket-level access for the Dataflow bucket."
  type        = bool
}

variable "versioning" {
  description = "Whether to enable versioning for the Dataflow bucket."
  type        = bool
}

variable "bigtable_zones" {
  description = "A map of regions to lists of zones in which to provision the Bigtable cluster."
  type        = map(list(string))
}

variable "bigtable_min_nodes" {
  description = "The minimum number of nodes for autoscaling."
  type        = number
}

variable "bigtable_max_nodes" {
  description = "The maximum number of nodes for autoscaling."
  type        = number
}

variable "bigtable_cpu_target" {
  description = "The target CPU utilization for autoscaling."
  type        = number
}

variable "bigtable_table_name" {
  description = "The name of the Bigtable table."
  type        = string
}

variable "family_third_type" {
  description = "The type value for the column family with family-third."
  type        = string
}

variable "bigtable_instance_name" {
  description = "The name of the Bigtable instance."
  type        = string
}

variable "bigtable_cluster_id" {
  description = "The ID of the Bigtable cluster."
  type        = string
}