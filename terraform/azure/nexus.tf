module "nexus" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.resource_group_name.name
  vm_hostname         = "nexus-vm"
  vm_os_simple        = "UbuntuServer"
  vm_os_publisher     = "Canonical"
  vm_os_offer         = "0001-com-ubuntu-server-jammy"
  vm_os_sku           = "22_04-lts-gen2"
  # admin_password      = ""
  remote_port         = "22"
  vm_size             = "Standard_B2s"

  # delete_os_disk_on_termination    = true
  # public_ip_dns       = ["${var.environment}nexus${var.region}"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.resource_group_name]
}

output "linux_vm_public_name_nexus" {
  value = module.nexus.public_ip_address
}

###   https://sleeplessbeastie.eu/2021/02/22/how-to-install-nexus-repository-manager-3/   ###
###   tail -f /opt/sonatype-work/nexus3/log/nexus.log ###

# resource "null_resource" "nexus" {
#   depends_on = [module.nexus]
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt update -qq",
#       "sudo apt upgrade",
#       "sudo apt install -y default-jre",
#       "sudo apt install -y fontconfig openjdk-17-jre",
#       "sudo apt install -y rpm",
#       "sudo apt install -y aptitude",
#       "sudo curl --silent https://repo.sonatype.com/repository/community-hosted/pki/deb-gpg/DEB-GPG-KEY-Sonatype.asc | sudo apt-key add -",
#       "sudo cat <<EOF | sudo tee -a /etc/apt/sources.list.d/sonatype-community.list deb [arch=all] https://repo.sonatype.com/repository/community-apt-hosted/ bionic main EOF",
#       "sudo apt update",
#       "sudo apt install nexus-repository-manager",
#       "sudo systemctl status nexus-repository-manager",
#       "sudo systemctl start nexus",
#       "sudo systemctl enable nexus",
#       "sudo systemctl restart nexus",
#     ]
#       connection {
#       type        = "ssh"
#       host        = module.nexus.public_ip_address[0]
#       user        = "azureuser"
#       private_key = file("~/.ssh/id_rsa")
#     }
#   }
# }

