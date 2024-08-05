module "openvpn" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.resource_group_name.name
  vm_hostname         = "openvpn-vm"
  vm_os_simple        = "UbuntuServer"
  vm_os_publisher     = "Canonical"
  vm_os_offer         = "0001-com-ubuntu-server-jammy"
  vm_os_sku           = "22_04-lts-gen2"
#   admin_password      = ""
#   remote_port         = "22"
  vm_size             = "Standard_B1s"

#   delete_os_disk_on_termination    = true
#   public_ip_dns       = ["${var.environment}openvpn${var.region}"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.resource_group_name]
}

output "linux_vm_public_name_openvpn" {
  value = module.openvpn.public_ip_address
}


# resource "null_resource" "openvpn" {
#   depends_on = [module.openvpn]
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "wget https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh",
#       "chmod +x openvpn-install.sh",
#       "sudo apt update -qq",
#       "./openvpn-install.sh",
#       "ss -tupln | grep openvpn",
#       "scp user@vpn-server:/path/to/configuration.ovpn /home/user",
#       "sudo apt install openvpn",
#       "openvpn --config /path/to/configuration.ovpn",
#     ]
#       connection {
#       type        = "ssh"
#       host        = module.openvpn.public_ip_address[0]
#       user        = "azureuser"
#       private_key = file("~/.ssh/id_rsa")
#     }
#   }
# }

