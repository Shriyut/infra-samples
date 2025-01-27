variable "project_id" {
  description = "The ID of the project in which to create the resources"
  type        = string
}

variable "regions" {
  description = "The list of regions in which to create the buckets"
  type        = list(string)
}

variable "bucket_name" {
  description = "The base name of the Cloud Storage buckets"
  type        = string
}

variable "force_destroy" {
  description = "The boolean option to delete all contained objects"
  type        = string
  default     = false
}

variable "storage_class" {
  description = "The storage class of the Cloud Storage buckets"
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "The boolean option to enable uniform bucket-level access"
  type        = bool
  default     = true
}

variable "versioning" {
  description = "The boolean option to enable uniform bucket-level access"
  type        = bool
  default     = true
}

variable "region_mapping" {
  description = "Mapping of regions to their short names"
  type        = map(string)
}

variable "bucket_types" {
  description = "The types of buckets to be created"
  type        = list(string)
  default     = ["staging", "temp", "op"]
}

variable "platform_service_account" {
  description = "The service account to be used for assigning roles"
  type        = string
}

variable "crypto_key_names" {
  description = "Map of region identifiers to the names of the created crypto keys"
  type        = map(string)
}