# Luke's scrappy Ansible test lab

Just learning. Starting with Azure.

They say
* Terraform for provisioning
* Ansible for configuration management

and

* Terraform = declarative = better
* Ansible = prodedural

but

* this is a hobby, no time to learn both
* Ansible can do the provisioning too
* so I'm learning Ansible for both

Also, I'm working in Azure, so: ARM templates? Bicep? Well, I may try to abstract out the provisioning steps, and make it amenable to deployment on other infrastructure (AWS, GCP, libvirt, VMware), so I'm using something cross-platform for now.