# azure-terraform-infra
Azure infra - Terraform Modules - 
Devops tools - Jenkins - Nexus - 
Azure Functions - Serverless - 
Compute servers


Terraform Modules


- Vnet module: https://registry.terraform.io/modules/Azure/network/azurerm/latest
- Compute module: https://registry.terraform.io/modules/Azure/compute/azurerm/latest
-

###
-Jenkins installation : 
    A null resource is a resource that does nothing (suprise) and is mainly used in conjunction with local or remote provisioners to allow the execution of some code.

    The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. To invoke a local process, see the local-exec provisioner instead. The remote-exec provisioner requires a connection and supports both ssh and winrm.

                resource "null resource" "web" {
# ...

            # Establishes connection to be used by all
            # generic remote provisioners (i.e. file/remote-exec)
            connection {
                type     = "ssh"
                user     = "root"
                password = var.root_password
                host     = self.public_ip
            }

            provisioner "remote-exec" {
                inline = [
                "puppet apply",
                "consul join ${aws_instance.web.private_ip}",
                ]
            }
            }



###

