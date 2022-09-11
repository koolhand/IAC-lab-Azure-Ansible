# TODO

* add rename and reboot steps
 * https://docs.ansible.com/ansible/latest/collections/ansible/windows/win_hostname_module.html
* put all in one file - provision, rename, promote DC
* provision non-DC server
* provision DC off server core image
* apply patches and reboot
* how to connect to OS instance named after provisioning to run
  * e.g. file touch https://www.ansible.com/blog/connecting-to-a-windows-host 
  * https://stackoverflow.com/questions/63237179/ansible-deploy-vm-then-run-additional-playbooks-against-new-host
* prompts for
  * region
  * RG name
* use hosts.ini and group_vars
* set up your own ansible user in custom PS1
* get cert down to ansible and stop disabling cert check
* register the NIC IP then set it as static
  * https://github.com/ansible-collections/azure/issues/386
  * https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_networkinterface_module.html#parameter-ip_configurations/private_ip_allocation_method
  * https://docs.microsoft.com/en-us/powershell/module/servicemanagement/azure.service/set-azurestaticvnetip?view=azuresmps-4.0.0
* improve security of WinRM not to be basic or NTLM
* map out architecture
  * subnets for DCs, servers, workstations, bastion DMZ / RDP gateway
  * NSGs for roles also
  * 2 x DCs in different availability zones
* work out how DHCP works with AD vs Azure DHCP - can't run DHCP in cloud so ??
* limit inbound RDP WinRM etc firewall to your IP
* how to set availability zones
* auto Windows NIC configure, DNS client configure
* auto DC promote
* auto domain join
* auto user create