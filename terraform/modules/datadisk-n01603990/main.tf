resource "azurerm_managed_disk" "data_disks" {
  count = length(var.machine_id)
  name = "managed_disk_${count.index+1}"
  location = var.location
  resource_group_name = var.rg-name
  disk_size_gb = 10
  create_option = "Empty"
  storage_account_type = "StandardSSD_LRS"
  tags = local.tags
  depends_on = [ var.machine_id ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  count = length(var.machine_id)
  virtual_machine_id = element(var.machine_id[*], count.index+1)
  managed_disk_id = element(azurerm_managed_disk.data_disks[*].id, count.index+1)
  lun = 0
  caching = "ReadWrite"
  depends_on = [ azurerm_managed_disk.data_disks ]
}