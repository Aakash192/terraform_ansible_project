variable "windows_avs" {
  default = "windows_avs"
}
variable "location" {}
variable "rg-name" {}
variable "machine_count" {}
variable "vm_name" {}
variable "subnetid" {}
variable "storage_account_uri" {}
variable "size" {
  default = "Standard_B1s"
}
variable "os_disk_attr_windows" {
  type = map(string)
  default = {
    "os_storage_account_type" = "StandardSSD_LRS"
    "os_disk_size"            = "128"
    "os_disk_caching"         = "ReadWrite"
  }
}
locals {
  tags = {
    Assignment     = "CCGC 5502 Automation Project"
    Name           = "Aakash.Suryavanshi"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}
variable "windows_publisher" {
  default = "MicrosoftWindowsServer"
}

variable "windows_offer" {
  default = "WindowsServer"
}

variable "windows_sku" {
  default = "2016-Datacenter"
}

variable "windows_version" {
  default = "latest"
}
variable "admin_password" {
  default = "LetMeInItsAdmin@"
}
variable "admin-username" {
  default = "aakashsuryavanshi"
}