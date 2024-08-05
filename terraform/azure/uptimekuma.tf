module "uptimekuma" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.resource_group_name.name
  vm_hostname         = "uptimekuma-vm"
  vm_os_simple        = "UbuntuServer"
  vm_os_publisher     = "Canonical"
  vm_os_offer         = "0001-com-ubuntu-server-jammy"
  vm_os_sku           = "22_04-lts-gen2"
#   admin_password      = ""
#   remote_port         = "22"
  vm_size             = "Standard_B1s"

#   delete_os_disk_on_termination    = true
#   public_ip_dns       = ["${var.environment}uptimekuma${var.region}"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.resource_group_name]
}

output "linux_vm_public_name_uptimekuma" {
  value = module.uptimekuma.public_ip_address
}


# resource "null_resource" "uptimekuma" {
#   depends_on = [module.uptimekuma]
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo docker volume create uptime-kuma",
#       "sudo docker container run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1",
#     ]
#       connection {
#       type        = "ssh"
#       host        = module.uptimekuma.public_ip_address[0]
#       user        = "azureuser"
#       private_key = file("~/.ssh/id_rsa")
#     }
#   }
# }

