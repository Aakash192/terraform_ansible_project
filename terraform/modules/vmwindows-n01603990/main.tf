resource "azurerm_availability_set" "windows_avs" {
  name                         = var.windows_avs
  location                     = var.location
  resource_group_name          = var.rg-name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                         = local.tags
}

resource "azurerm_network_interface" "windows_nic" {
  name                = "${var.vm_name}-nic-${format("%1d", count.index + 1)}"
  location            = var.location
  resource_group_name = var.rg-name
  count               = var.machine_count
  tags                = local.tags

  ip_configuration {
    name                          = "${var.vm_name}-ipconfig-${format("%1d", count.index + 1)}"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.windows_pip[*].id, count.index + 1)
  }
}

resource "azurerm_public_ip" "windows_pip" {
  count               = var.machine_count
  name                = "${var.vm_name}-pip-${format("%1d", count.index + 1)}"
  resource_group_name = var.rg-name
  location            = var.location
  domain_name_label   = "${var.vm_name}-${format("%1d", count.index + 1)}"
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_windows_virtual_machine" "vmwindows" {
  availability_set_id = azurerm_availability_set.windows_avs.id
  count                 = var.machine_count
  name                  = "${var.vm_name}-${format("%1d", count.index + 1)}"
  resource_group_name   = var.rg-name
  location              = var.location
  size                  = var.size
  admin_username        = var.admin-username
  admin_password        = var.admin_password
  network_interface_ids = [element(azurerm_network_interface.windows_nic[*].id, count.index + 1)]
  tags                  = local.tags

  winrm_listener {
    protocol = "Http"
  }

  os_disk {
    name                 = "${var.vm_name}-os-disk-${format("%1d", count.index + 1)}"
    caching              = var.os_disk_attr_windows["os_disk_caching"]
    disk_size_gb         = var.os_disk_attr_windows["os_disk_size"]
    storage_account_type = var.os_disk_attr_windows["os_storage_account_type"]
  }

  source_image_reference {
    publisher = var.windows_publisher
    offer     = var.windows_offer
    sku       = var.windows_sku
    version   = var.windows_version
  }
  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }
}

resource "azurerm_virtual_machine_extension" "windows_antimalware" {
  count                = var.machine_count
  virtual_machine_id   = element(azurerm_windows_virtual_machine.vmwindows[*].id, count.index + 1)
  name                 = "${var.vm_name}-antimalware-${format("%1d", count.index + 1)}"
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.3"
  tags                 = local.tags
}