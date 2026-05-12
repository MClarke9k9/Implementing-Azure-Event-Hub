variable "resource_group_name" {
  description = "Existing Azure Resource Group"
  type        = string
}

variable "location" {
  default = "East US"
  type    = string
}

variable "name_suffix" {
  default = "mark"
  type    = string
}