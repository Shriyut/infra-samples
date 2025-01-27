variable "project_id" {
  description = "The ID of the project in which to create the resources"
  type        = string
}

variable "locations" {
  description = "The list of locations in which to create the repositories"
  type        = list(string)
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
}

variable "format" {
  description = "The format of the Artifact Registry repository"
  type        = string
  default     = "DOCKER"
}

variable "region_mapping" {
  description = "Mapping of regions to their short names"
  type        = map(string)
}

variable "description" {
  description = "Description of the Artifact Registry repository"
  type        = string
}

variable "crypto_key_names" {
  description = "Map of region identifiers to the names of the created crypto keys"
  type        = map(string)
}

variable "platform_service_account" {
  description = "The service account to be used for assigning roles"
  type        = string
}