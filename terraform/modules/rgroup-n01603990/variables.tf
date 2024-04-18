variable "rname" {}

variable "location" {}

locals {
  tags = {
    Assignment     = "CCGC 5502 Automation Project"
    Name           = "Aakash.Suryavanshi"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
} 