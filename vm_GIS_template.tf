provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_subscription" "current" {}

locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  rg_name         = "rg-portfolio"
  svc_name        = "portfolio"
  vm_user         = "useradmin"
  kv_name         = "kv-geoportfolio"
  kvsecret_name   = "vm-passwd"
  location        = "westeurope"
  tag1_value      = "Guilherme Viegas"
  tag2_value      = "Portfolio"
}

data "azurerm_key_vault_secret" "tfazkvsecretsubscriptionid" {
  name         = "baitatec-stgacc-conx-key"
  key_vault_id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.rg_name}/providers/Microsoft.KeyVault/vaults/${local.kv_name}"
}

data "azurerm_key_vault_secret" "tfazkvsecretgithubtoken" {
  name         = "gistemplate-github-token"
  key_vault_id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.rg_name}/providers/Microsoft.KeyVault/vaults/${local.kv_name}"
}

data "azurerm_key_vault_secret" "tfazkvsecretvmpasswd" {
  name         = local.kvsecret_name
  key_vault_id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.rg_name}/providers/Microsoft.KeyVault/vaults/${local.kv_name}"
}

resource "azurerm_virtual_network" "tfazvnet" {
  name                = "${local.svc_name}vnet"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = local.rg_name
  tags = {
    Owner   = local.tag1_value
    Project = local.tag2_value
  }
}

resource "azurerm_subnet" "tfazsubnet" {
  name                 = "${local.svc_name}snet"
  resource_group_name  = local.rg_name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.tfazvnet.name
}

resource "azurerm_public_ip" "tfazpubip" {
  name                = "${local.svc_name}pubip"
  location            = local.location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  tags = {
    Owner   = local.tag1_value
    Project = local.tag2_value
  }
}

resource "azurerm_network_interface" "tfaznic" {
  name                = "${local.svc_name}nic"
  location            = local.location
  resource_group_name = local.rg_name
  ip_configuration {
    name                          = "${local.svc_name}intip"
    subnet_id                     = azurerm_subnet.tfazsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfazpubip.id
  }
  tags = {
    Owner   = local.tag1_value
    Project = local.tag2_value
  }
}

resource "azurerm_linux_virtual_machine" "tfazvmachine" {
  name                   = "${local.svc_name}vm"
  location               = local.location
  resource_group_name    = local.rg_name
  admin_username         = local.vm_user
  admin_password         = data.azurerm_key_vault_secret.tfazkvsecretvmpasswd.value
  computer_name          = "${local.svc_name}machine"
  disable_password_authentication = false
  network_interface_ids  = [azurerm_network_interface.tfaznic.id]
  size                   = "Standard_B2s"
  os_disk {
    name                 = "${local.svc_name}osdisk"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "128"
    caching              = "ReadWrite"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-lts"
    version   = "latest"
  }
  connection {
    type     = "ssh"
    host     = azurerm_public_ip.tfazpubip.ip_address
    user     = local.vm_user
    password = data.azurerm_key_vault_secret.tfazkvsecretvmpasswd.value
  }
  #provisioner "file" {
  #  source      = "init_prepare_vm.sh"
  #  destination = "/tmp/init_prepare_vm.sh"
  #}
  #provisioner "remote-exec" {
  #  inline = [
  #    "chmod +x /tmp/init_prepare_vm.sh",
  #    "sh /tmp/init_prepare_vm.sh \"${azurerm_public_ip.tfazpubip.ip_address}\" \"${data.azurerm_key_vault_secret.tfazkvsecretsubscriptionid.value}\" \"${data.azurerm_key_vault_secret.tfazkvsecretgithubtoken.value}\" >> /tmp/init_prepare_vm.log 2>&1 "
  #  ]
  #}
  tags = {
    Owner   = local.tag1_value
    Project = local.tag2_value
  }
}

resource "azurerm_network_security_group" "tfaznsg" {
  name                = "${local.svc_name}nsg"
  location            = local.location
  resource_group_name = local.rg_name
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-GeoServer"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-PostgreSQL"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-PGadmin"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-Outbound"
    priority                   = 2000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Deny-Inbound"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    Owner   = local.tag1_value
    Project = local.tag2_value
  }
}

resource "azurerm_network_interface_security_group_association" "tfazninsg" {
  network_interface_id      = azurerm_network_interface.tfaznic.id
  network_security_group_id = azurerm_network_security_group.tfaznsg.id
}

output "public_ip_address" {
  value = azurerm_public_ip.tfazpubip.ip_address
}
