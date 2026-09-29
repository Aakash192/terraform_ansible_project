variable "db_admin_password" {
  description = "Administrator password for the PostgreSQL server."
  type        = string
  sensitive   = true
}

variable "windows_admin_password" {
  description = "Administrator password for the Windows VM."
  type        = string
  sensitive   = true
}
