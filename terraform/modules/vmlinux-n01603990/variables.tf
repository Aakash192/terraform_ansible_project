variable "location" {}
variable "rg-name" {}
variable "linux_avs" {}
variable "subnet_id" {}
variable "admin_username" {}
variable "storage_account_uri" {}
variable "nwatcher_publisher" {
  default = "Microsoft.Azure.NetworkWatcher"
}
variable "nwatcher_type" {
  default = "NetworkWatcherAgentLinux"
}
variable "azmonitor_publisher" {
  default = "Microsoft.Azure.Monitor"
}
variable "azmonitor_type" {
  default = "AzureMonitorLinuxAgent"
}


variable "linux_name" {
  type = map(string)
}

locals {
  tags = {
    Assignment     = "CCGC 5502 Automation Project"
    Name           = "Aakash.Suryavanshi"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}

variable "os_disk_attr" {
  type = map(string)
  default = {
    "os_storage_account_type" = "Premium_LRS"
    "os_disk_size"            = "32"
    "os_disk_caching"         = "ReadWrite"
  }
}

variable "linux_publisher" {
  default = "OpenLogic"
}

variable "linux_offer" {
  default = "CentOS"
}

variable "linux_sku" {
  default = "8_2"
}

variable "linux_version" {
  default = "latest"
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "priv_key" {
  default = "~/.ssh/id_rsa"
}