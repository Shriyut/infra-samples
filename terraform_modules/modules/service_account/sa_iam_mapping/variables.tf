variable "project" {
  description = "The ID of the project in which to create the service account"
  type        = string
}

variable "service_account_id" {
  description = "The ID of the service account"
  type        = string
}

variable "display_name" {
  description = "The display name of the service account"
  type        = string
}

variable "description" {
  description = "The description of the service account"
  type        = string
  default     = ""
}

variable "roles" {
  description = "List of roles to assign to the service account"
  type        = list(string)
}

variable "disabled" {
  description = "Whether the service account is disabled"
  type        = bool
  default     = false
}

variable "create_ignore_already_exists" {
  description = "Whether to ignore errors if the service account already exists"
  type        = bool
  default     = false
}