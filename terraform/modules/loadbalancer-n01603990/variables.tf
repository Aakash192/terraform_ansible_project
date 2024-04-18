variable "rg-name" {}
variable "location" {}
variable "nic_id" {}
variable "ip_config" {}
locals {
  tags = {
    Assignment     = "CCGC 5502 Automation Project"
    Name           = "Aakash.Suryavanshi"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}