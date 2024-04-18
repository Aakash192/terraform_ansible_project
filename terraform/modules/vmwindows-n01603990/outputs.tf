output "WindowsHostNames" {
  value = [azurerm_windows_virtual_machine.vmwindows[*].name]
}

output "WindowsDomainNames" {
  value = [azurerm_public_ip.windows_pip[*].fqdn]
}

output "WindowsPrivateIP" {
  value = [azurerm_windows_virtual_machine.vmwindows[*].private_ip_address]
}

output "WindowsPublicIP" {
  value = [azurerm_windows_virtual_machine.vmwindows[*].public_ip_address]
}

output "WindowsVMids" {
  value = tolist([azurerm_windows_virtual_machine.vmwindows[*].id])
}