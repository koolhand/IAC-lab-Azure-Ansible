# See https://docs.microsoft.com/en-au/azure/developer/ansible/install-on-linux-vm

# ---------------------------------------------------------------------------
## set up az azure-cli
# ---------------------------------------------------------------------------

# set up Azure repo on RHEL / Rocky Linux / Alma Linux / CentOS / Fedora etc
# sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

## ACTUALLY SKIPPED THIS - seems to be written in Python and conflicts with newer azure modules installed as dependencies by ansible galaxy
# echo -e "[azure-cli]
# name=Azure CLI
# baseurl=https://packages.microsoft.com/yumrepos/azure-cli
# enabled=1
# gpgcheck=1
# gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

# ---------------------------------------------------------------------------
## set up Ansible learning folders
# ---------------------------------------------------------------------------

export PROJECT=~/source/learn-ansible
mkdir -p $PROJECT
cd $PROJECT
python -m venv $PROJECT/.venv
source $PROJECT/.venv/bin/activate


# ---------------------------------------------------------------------------

# install Ansible and WinRM
pip3 install --upgrade --requirement $PROJECT/requirements.txt
# pip3 install ansible
# pip3 install "pywinrm>=0.2.2"
pip3 install --upgrade --requirement $PROJECT/requirements-dev.txt
# pip3 install --upgrade pip


# install Azure modules
# ideally pip install -U -I 'ansible[azure]' would work to get azure stuff but no
# use collections, instructions old modules are old and broken, you get conflicting imports etc
# https://docs.ansible.com/ansible/latest/collections/azure/azcollection/index.html#azure-azcollection
# https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#installing-collections-with-ansible-galaxy
ansible-galaxy collection install azure.azcollection --upgrade
pip3 install --upgrade --requirement ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

# but are you sure you can't get the latest and make it work
# pip freeze | grep azure | cut -f 1 -d= | xargs -L1 pip3 install --upgrade
cut -f 1 -d= ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt | xargs -L1 pip3 install --upgrade

# ---------------------------------------------------------------------------
#  set up creds in Azure
# ---------------------------------------------------------------------------
# See https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current
# created app registration in AAD
# https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps
# then subscriptions https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade
# > IAM > Add role assignment > Owner
# could probably be more granular just for creating/deleting RG
# echo -e "export AZURE_SUBSCRIPTION_ID=#########-####-####-####-############
# export AZURE_CLIENT_ID=########-####-####-####-############
# export AZURE_SECRET=########################################
# export AZURE_TENANT=########-####-####-####-############" | tee ~/azurecreds.sh
# chmod +x ~/azurecreds.sh
# ~/azurecreds.sh
# or
eval "$(awk -F "="  'NR>1 {print "AZURE_" toupper($1) "=" $2}' ~/.azure/credentials)"

# ---------------------------------------------------------------------------
## dummy single RG test
# ---------------------------------------------------------------------------
## one-liner
ansible localhost -m azure.azcollection.azure_rm_resourcegroup -a "name=ansible-test location=australiaeast"
## playbook
mkdir -p $PROJECT/basic-ansible-check
cd $PROJECT/basic-ansible-check
## <--- edit files here
ansible-playbook $PROJECT/basic-ansible-check/create_rg.yml # create
ansible-playbook $PROJECT/basic-ansible-check/delete_rg.yml # delete / cleanup

# ---------------------------------------------------------------------------
## set up a Windows VM and connect over WinRM
# ---------------------------------------------------------------------------

mkdir -p $PROJECT/single-windows-vm-winrm
cd $PROJECT/single-windows-vm-winrm

ansible-playbook $PROJECT/single-windows-vm-winrm/windows-vm-create.yml # get the public IP
pip3 install "pywinrm>=0.2.2" # needed for WinRM connection see https://access.redhat.com/solutions/3356681
ansible-playbook $PROJECT/single-windows-vm-winrm/windows-vm-connect.yml -i PUBLICIPADDRESSHERE,
ansible-playbook $PROJECT/single-windows-vm-winrm/windows-vm-delete.yml
