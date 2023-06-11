# Ansible learning

See Microsoft [Azure developer docs about installing Linux on Azure VM](https://docs.microsoft.com/en-au/azure/developer/ansible/install-on-linux-vm)

## Set up Ansible learning folders

```sh
export PROJECT=~/source/learn-ansible
mkdir -p $PROJECT
cd $PROJECT
python -m venv $PROJECT/.venv
source $PROJECT/.venv/bin/activate
```

## install Ansible and WinRM

```sh
pip3 install --upgrade --requirement $PROJECT/requirements.txt
pip3 install --upgrade --requirement $PROJECT/requirements-dev.txt
```

## install Azure modules

Ideally ```pip install -U -I 'ansible[azure]'``` would work to get Azure requirements
but no, instructions old modules are old and broken, you get conflicting imports etc.

Use [Ansible Galaxy collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#installing-collections-with-ansible-galaxy)
in particulare the [Azure collection](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/index.html#azure-azcollection)

```sh
ansible-galaxy collection install azure.azcollection --upgrade
pip3 install --upgrade --requirement ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
```

Tried getting the latest of everything to make it work

```sh
# pip freeze | grep azure | cut -f 1 -d= | xargs -L1 pip3 install --upgrade
cut -f 1 -d= ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt | xargs -L1 pip3 install --upgrade
```

but no - bugs in various bit means the frozen versions in the collection are needed..

## Set up Azure credentials

See [Azure documentation about role assignments](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current)

* created an app registration in [Azure AD portal](https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps)
* then under [Subscriptions](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade)
  * `> IAM > Add role assignment > Owner
  * (could probably be more granular just for creating/deleting RG)

Created a shell script for setting credentials:

```sh
echo -e "export AZURE_SUBSCRIPTION_ID=#########-####-####-####-############
export AZURE_CLIENT_ID=########-####-####-####-############
export AZURE_SECRET=########################################
export AZURE_TENANT=########-####-####-####-############" | tee ~/azurecreds.sh
chmod +x ~/azurecreds.sh
~/azurecreds.sh
```

Not sure if you need this if ~/.azure/credentials gets created by (what was it?)

## Dummy single RG test

A one-liner using ```ansible``` (not ```ansible-playbook```):

```sh
ansible localhost -m azure.azcollection.azure_rm_resourcegroup -a "name=ansible-test location=australiaeast"
```

## playbook for a basic check

```sh
mkdir -p $PROJECT/basic-ansible-check
cd $PROJECT/basic-ansible-check
## <--- edit files here
ansible-playbook $PROJECT/basic-ansible-check/create.yml # create
ansible-playbook $PROJECT/basic-ansible-check/destroy.yml # delete / cleanup
```

## playbook for a Windows VM and connect over WinRM

```sh
mkdir -p $PROJECT/single-win-vm
cd $PROJECT/single-win-vm

ansible-playbook $PROJECT/single-win-vm/1-create.yml # get the public IP
pip3 install "pywinrm>=0.2.2" # needed for WinRM connection see https://access.redhat.com/solutions/3356681

ansible-playbook $PROJECT/single-win-vm/2-test.yml -i x.x.x.x, # public IP whatever it is
# add IP to winhosts.ini
ansible-playbook $PROJECT/single-win-vm/2-test.yml -i $PROJECT/single-win-vm/winhosts.ini 
```

## more Ansible modules

* actually manage the Windows OS with [win_feature_module](https://docs.ansible.com/ansible/latest/collections/ansible/windows/win_feature_module.html)
* install software with [chocolatey](https://docs.ansible.com/ansible/latest/collections/chocolatey/chocolatey/win_chocolatey_module.html)

```sh
ansible-galaxy collection install ansible.windows --upgrade
ansible-galaxy collection install chocolatey.chocolatey
pip3 install --upgrade --requirement ~/.ansible/collections/ansible_collections/chocolatey/chocolatey/requirements.txt
```
