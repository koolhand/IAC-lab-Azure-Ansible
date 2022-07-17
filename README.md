# Luke's scrappy Ansible test lab

Just learning. Starting with Azure.

## Why Ansible?

They say

* Terraform for provisioning
* Ansible for configuration management

and

* Terraform = declarative = better
* Ansible = prodedural

but

* this is a hobby, no time to learn both
* Ansible can do the provisioning too
* I've got some basic Python
* so I'm learning Ansible for both

Also, I'm working in Azure, so there are Microsoft-preferred options: ARM
templates, and now Bicep. Why not use those?

* I may try to abstract out the infrastructure provisioning steps, creating
labs that could deploy other infrastructure (AWS, GCP, libvirt, or VMware). The
options available are different in work and home life.
* So I'm using something cross-platform for now, to give me that option later.

## Why this repo

The main idea is just to set up an Active Directory lab, on (insert
infrastructure here).

I want to learn some IaC anyway - and it should help me recreate a lab from
scratch at the push of a button.

The Microsoft documentation for using Ansible with Azure tends to have steps
that fail in a bunch of places, because it's pointing at older Azure modules,
modules that conflict with azure-cli, inconsistent use of variables vs
hardcoded. So I'll try to iron some of that out, and record how I got there.

## Things to try

* An AD test lab
  * start with domain controller, static IP, automatically promoting itself
  * improve with different availability zones
  * add RDP gateways in DMZ and lock down firewall
  * add member servers x 2
  * Add patching with WSUS role on a server, or direct
  * set up Group Policy Object structure
    * apply hardening template (Microsoft Baseline or CIS)
    * set up Group Policy management AGPM
    * set up method to export policy and import to non-domain-joined server
  * improve with credentials in key vault
  * lock down WinRM authentication, how to get Ansible using a more secure
  method from the get-go
  * add workstations as Azure Virtual Desktops
  * Level up to AAD connect sync, hybrid-joined or AAD-only joined
