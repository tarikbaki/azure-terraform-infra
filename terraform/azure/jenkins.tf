module "jenkins" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.resource_group_name.name
  vm_hostname         = "jenkins-vm"
  vm_os_simple        = "UbuntuServer"
  # admin_password      = ""
  remote_port         = "22"
  vm_size             = "Standard_B2s"
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
      # "sudo apt install -y default-jre",                    upgrade java version 11 to 17 
      "sudo apt install -y fontconfig openjdk-17-jre",
      "sudo apt install -y aptitude",
      "sudo apt install -y jenkins",
      "sudo apt install systemd",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
      "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080",
      "sudo sh -c \"iptables-save > /etc/iptables.rules\"",
      "echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections",
      "echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections",
      "sudo apt-get -y install iptables-persistent",
      "sudo ufw allow 8080"
    ]
      connection {
      type        = "ssh"
      host        = module.jenkins.public_ip_address[0]
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
