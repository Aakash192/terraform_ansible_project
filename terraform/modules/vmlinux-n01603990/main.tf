resource "azurerm_availability_set" "linux_avs" {
  name                         = var.linux_avs
  location                     = var.location
  resource_group_name          = var.rg-name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                         = local.tags
}

resource "azurerm_network_interface" "linux_nic" {
  for_each            = var.linux_name
  location            = var.location
  resource_group_name = var.rg-name
  name                = "${each.key}-nic"
  tags                = local.tags
  ip_configuration {
    name                          = "${each.key}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_pip[each.key].id
  }
}

resource "azurerm_public_ip" "linux_pip" {
  for_each            = var.linux_name
  name                = "${each.key}-pip"
  resource_group_name = var.rg-name
  location            = var.location
  domain_name_label   = each.key
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each              = var.linux_name
  name                  = each.key
  location              = var.location
  resource_group_name   = var.rg-name
  size                  = each.value
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.linux_nic[each.key].id]
  tags                  = local.tags
  availability_set_id = azurerm_availability_set.linux_avs.id
  os_disk {
    name                 = "${each.key}-osdisk"
    caching              = var.os_disk_attr["os_disk_caching"]
    disk_size_gb         = var.os_disk_attr["os_disk_size"]
    storage_account_type = var.os_disk_attr["os_storage_account_type"]
  }
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.pub_key)
  }
  source_image_reference {
    publisher = var.linux_publisher
    offer     = var.linux_offer
    sku       = var.linux_sku
    version   = var.linux_version
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

}

resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each             = var.linux_name
  name                 = "${var.nwatcher_type}-${each.key}"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher            = var.nwatcher_publisher
  type                 = var.nwatcher_type
  type_handler_version = "1.4"
  tags                 = local.tags
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each             = var.linux_name
  name                 = "${var.azmonitor_type}-${each.key}"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher            = var.azmonitor_publisher
  type                 = var.azmonitor_type
  type_handler_version = "1.6"
  tags                 = local.tags
}