output "rgname" {
  value = module.rgroup-n01603990.rg-name.name
}

output "vnetname" {
  value = module.network-n01603990.vnetdetails.name
}

output "subnetname" {
  value = module.network-n01603990.subnetdetails.name
}

output "workspace_name" {
  value = module.common-n01603990.workspace_name
}

output "vault_name" {
  value = module.common-n01603990.vault_name
}

output "storage_account_name" {
  value = module.common-n01603990.storage_account.name
}

output "LinuxHostNames" {
  value = module.linux-n01603990.LinuxVMNames
}

output "LinuxDomianNames" {
  value = module.linux-n01603990.LinuxDomainNames
}

output "LinuxPrivateAddresses" {
  value = module.linux-n01603990.LinuxPrivateAddresses
}

output "LinuxPublicAddresses" {
  value = module.linux-n01603990.LinuxPublicAddresses
}

output "WindowsHostNames" {
  value = module.vmwindows-n01603990.WindowsHostNames
}

output "WindowsDomainNames" {
  value = module.vmwindows-n01603990.WindowsDomainNames
}

output "WindowsPrivateIPAddress" {
  value = module.vmwindows-n01603990.WindowsPrivateIP
}

output "WindowsPublicIPAddress" {
  value = module.vmwindows-n01603990.WindowsPublicIP
}

output "lbname" {
  value = module.loadbalancer-n01603990.lb_name
}

output "databasename" {
  value = module.database-n01603990.dbname
}