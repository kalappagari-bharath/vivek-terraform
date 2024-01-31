variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "trgid" {
  type = string
}

variable "law" {
  type = string
}

variable "diagnosticsettings_name" {
  type = string
}

variable "logs" {
  description = "List of log categories to log."
  type        = list(string)
  default     = []
}
