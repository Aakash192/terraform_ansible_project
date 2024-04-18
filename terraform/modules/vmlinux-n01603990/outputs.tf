output "LinuxVMNames" {
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].name
}

output "LinuxDomainNames" {
  value = values(azurerm_public_ip.linux_pip)[*].fqdn
}

output "LinuxPrivateAddresses" {
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].private_ip_address
}

output "LinuxPublicAddresses" {
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].public_ip_address
}

output "LinuxVMids" {
  value = tolist(values(azurerm_linux_virtual_machine.linux_vm)[*].id)
}

output "nic_id" {
  value = tolist(values(azurerm_network_interface.linux_nic)[*].id)
}

output "ip_config" {
  value = [for nic in azurerm_network_interface.linux_nic : nic.ip_configuration[0].name]
}