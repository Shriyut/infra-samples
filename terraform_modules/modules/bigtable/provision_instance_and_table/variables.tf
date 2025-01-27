variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "regions" {
  description = "The region in which to provision resources."
  type        = list(string)
}

variable "instance_name" {
  description = "The name of the Bigtable instance."
  type        = string
}

variable "cluster_id" {
  description = "The ID of the Bigtable cluster."
  type        = string
}

variable "zones" {
  description = "A map of regions to lists of zones in which to provision the Bigtable cluster."
  type        = map(list(string))
}

variable "min_nodes" {
  description = "The minimum number of nodes for autoscaling."
  type        = number
}

variable "max_nodes" {
  description = "The maximum number of nodes for autoscaling."
  type        = number
}

variable "cpu_target" {
  description = "The target CPU utilization for autoscaling."
  type        = number
}

variable "table_name" {
  description = "The name of the Bigtable table."
  type        = string
}

variable "family_third_type" {
  description = "The type value for the column family with family-third."
  type        = string
}

variable "region_mapping" {
  description = "Mapping of regions to their short names"
  type        = map(string)
}

variable "platform_service_account" {
  description = "The service account to be used for assigning roles"
  type        = string
}

variable "crypto_key_names" {
  description = "Map of region identifiers to the names of the created crypto keys"
  type        = map(string)
}

variable "zone_mapping" {
  description = "Mapping of zones to their short names"
  type        = map(string)
}