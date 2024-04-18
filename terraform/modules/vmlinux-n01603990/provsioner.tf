resource "null_resource" "linux_provisioner" {
  for_each = var.linux_name
  depends_on = [ azurerm_linux_virtual_machine.linux_vm ]
  provisioner "remote-exec" {
    inline = [ "echo Hostname is : $(hostname)" ]
  }
  connection {
    type = "ssh"
    user = var.admin_username
    private_key = file(var.priv_key)
    host = azurerm_linux_virtual_machine.linux_vm[each.key].public_ip_address
  }
}