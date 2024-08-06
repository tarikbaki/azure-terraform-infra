module "jenkins" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.resource_group_name.name
  vm_hostname         = "jenkins-vm"
  vm_os_simple        = "UbuntuServer"
  vm_os_publisher     = "Canonical"
  vm_os_offer         = "0001-com-ubuntu-server-jammy"
  vm_os_sku           = "22_04-lts-gen2"
  # admin_password      = ""
  remote_port         = "22"
  vm_size             = "Standard_B2ms"

  # delete_os_disk_on_termination    = true
  # public_ip_dns       = ["${var.environment}jenkins${var.region}"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.resource_group_name]
}

output "linux_vm_public_name" {
  value = module.jenkins.public_ip_address
}


resource "null_resource" "jenkins" {
  depends_on = [module.jenkins]
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update -qq",
      "sudo apt install -y rpm",
      "sudo apt install -y aptitude",
      "sudo apt install nano",
      "sudo apt install -y jenkins",
      "sudo apt install -y systemd",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
      "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080",
      "sudo sh -c \"iptables-save > /etc/iptables.rules\"",
      "echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections",
      "echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections",
      "sudo apt-get -y install iptables-persistent",
      "sudo ufw allow 8080",
      "sudo apt install -y openjdk-17-jdk",
      "sudo systemctl restart jenkins",
      "sudo echo '10.0.1.5 cur-nexus.vngrs.com' | sudo tee -a /etc/hosts"
    ]
      connection {
      type        = "ssh"
      host        = module.jenkins.public_ip_address[0]
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
