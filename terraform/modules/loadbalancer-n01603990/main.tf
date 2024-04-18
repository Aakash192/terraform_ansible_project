resource "azurerm_lb" "assignment_lb" {
  name = "AssignmentLB"
  resource_group_name = var.rg-name
  location = var.location
  sku = "Basic"
  tags = local.tags
  frontend_ip_configuration {
    name = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_public_ip" "lb_ip" {
  name = "LBIP"
  resource_group_name = var.rg-name
  location = var.location
  allocation_method = "Static"
  sku = "Basic"
  tags = local.tags
}

resource "azurerm_lb_backend_address_pool" "backend_lb_pool" {
  loadbalancer_id = azurerm_lb.assignment_lb.id
  name = "backend_pool_"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_association" {
  count = length(var.nic_id)
  network_interface_id = element(var.nic_id[*],count.index+1)
  ip_configuration_name = element(var.ip_config[*], count.index+1)
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_lb_pool.id
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.assignment_lb.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.assignment_lb.id
  name            = "http-working-port"
  port            = 80
  interval_in_seconds = 15
  number_of_probes = 2
}