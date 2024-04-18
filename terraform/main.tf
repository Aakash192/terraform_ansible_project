module "rgroup-n01603990" {
  source   = "./modules/rgroup-n01603990"
  rname    = "rgroup-n01603990"
  location = "canadacentral"
}

module "network-n01603990" {
  source             = "./modules/network-n01603990"
  rg-name            = module.rgroup-n01603990.rg-name.name
  location           = module.rgroup-n01603990.rg-name.location
  vnet-name          = "n01603990-VNET"
  vnet-address-space = ["10.0.0.0/16"]
  subnet-name        = "n01603990-SUBENT"
  subnet-add-space   = ["10.0.1.0/24"]
  nsg-name           = "n01603990-NSG"
}

module "common-n01603990" {
  source               = "./modules/common-n01603990"
  location             = module.rgroup-n01603990.rg-name.location
  rg-name              = module.rgroup-n01603990.rg-name.name
  vault_name           = "vault-0160"
  workspace_name       = "workspace-0160"
  storage_account_name = "san01603990"
}

module "linux-n01603990" {
  source   = "./modules/vmlinux-n01603990"
  location = module.rgroup-n01603990.rg-name.location
  rg-name  = module.rgroup-n01603990.rg-name.name
  linux_name = {
    "n01603990-c-vm1" = "Standard_B1s"
    "n01603990-c-vm2" = "Standard_B1s"
    "n01603990-c-vm3" = "Standard_B1s"
  }
  admin_username      = "aakashsuryavanshi"
  linux_avs           = "LinuxAVS"
  subnet_id           = module.network-n01603990.subnetdetails.id
  storage_account_uri = module.common-n01603990.storage_account.primary_blob_endpoint
}

module "vmwindows-n01603990" {
  source              = "./modules/vmwindows-n01603990"
  location            = module.rgroup-n01603990.rg-name.location
  rg-name             = module.rgroup-n01603990.rg-name.name
  vm_name             = "n0160-w-vm"
  subnetid            = module.network-n01603990.subnetdetails.id
  storage_account_uri = module.common-n01603990.storage_account.primary_blob_endpoint
  machine_count       = 1
}
module "datadisk-n01603990" {
  source = "./modules/datadisk-n01603990"
  location            = module.rgroup-n01603990.rg-name.location
  rg-name             = module.rgroup-n01603990.rg-name.name
  machine_id = flatten([module.vmwindows-n01603990.WindowsVMids, module.linux-n01603990.LinuxVMids])
}

module "loadbalancer-n01603990" {
  source = "./modules/loadbalancer-n01603990"
  location = module.rgroup-n01603990.rg-name.location
  rg-name = module.rgroup-n01603990.rg-name.name
  nic_id = module.linux-n01603990.nic_id
  ip_config = module.linux-n01603990.ip_config
}

module "database-n01603990" {
  source = "./modules/database-n01603990"
  location = module.rgroup-n01603990.rg-name.location
  rg-name = module.rgroup-n01603990.rg-name.name
  db_name = "assignmentdbn0160"
  administrator_login = "plsqladmin"
  administrator_login_password = "LetMeInItsAdmin@"
}