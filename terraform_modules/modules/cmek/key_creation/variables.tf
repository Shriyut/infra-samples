variable "project_id" {
  description = "The ID of the project in which to create the resources"
  type        = string
}

variable "regions" {
  description = "The list of regions in which to create the resources"
  type        = list(string)
}

variable "key_ring_name" {
  description = "The name of the KMS key ring"
  type        = string
}

variable "crypto_key_name" {
  description = "The name of the KMS crypto key"
  type        = string
}

variable "rotation_period" {
  description = "The rotation period of the KMS crypto key"
  type        = string
  default     = "84400s"  # 1 day
}

variable "region_mapping" {
  description = "Mapping of regions to their short names"
  type        = map(string)
}

variable "platform_service_account" {
  description = "The service account to be used for assigning roles"
  type        = string
}