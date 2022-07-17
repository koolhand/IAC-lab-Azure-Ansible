# TODO

* set region
* register the NIC IP then set it as static
  * https://github.com/ansible-collections/azure/issues/386
  * https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_networkinterface_module.html#parameter-ip_configurations/private_ip_allocation_method
  * https://docs.microsoft.com/en-us/powershell/module/servicemanagement/azure.service/set-azurestaticvnetip?view=azuresmps-4.0.0

* improve security of WinRM not to be basic or NTLM
* map out architecture
  * subnets for DCs, servers, workstations, bastion DMZ / RDP gateway
  * NSGs for roles also
  * 2 x DCs in different availability zones
  * 
* work out how DHCP works with AD vs Azure DHCP - can't run DHCP in cloud so ??
* limit inbound RDP WinRM etc firewall to your IP
* how to set availability zones
* auto Windows NIC configure, DNS client configure
* auto DC promote
* auto domain join
* auto user create