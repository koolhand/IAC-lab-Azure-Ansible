# See https://docs.microsoft.com/en-au/azure/developer/ansible/install-on-linux-vm

# ---------------------------------------------------------------------------
# set up Azure repo on RHEL / Rocky Linux / Alma Linux / CentOS / Fedora etc
# ---------------------------------------------------------------------------

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

## set up az azure-cli
## ACTUALLY SKIPPED THIS - seems to be written in Python and conflicts with newer azure modules installed as dependencies by ansible galaxy
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

# ---------------------------------------------------------------------------
## set up Ansible learning folders
# ---------------------------------------------------------------------------

mkdir -p ~/source/learn-ansible
cd ~/source/learn-ansible
python -m venv .venv
source ./.venv/bin/activate

# install Ansible and WinRM
pip install -r requirements.txt --uppgrade
# pip install ansible
# pip install "pywinrm>=0.2.2"

# install Azure modules
#S use collections, instructions old modules are old and broken, you get conflicting imports etc
# https://docs.ansible.com/ansible/latest/collections/azure/azcollection/index.html#azure-azcollection
# https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#installing-collections-with-ansible-galaxy
ansible-galaxy collection install azure.azcollection
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt --upgrade

# ---------------------------------------------------------------------------
#  set up creds in Azure
# ---------------------------------------------------------------------------

# See https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current

# created app registration in AAD
# https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps

# then subscriptions https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade
# > IAM > Add role assignment > Owner
# could probably be more granular just for creating/deleting RG

echo -e "export AZURE_SUBSCRIPTION_ID=#########-####-####-####-############
export AZURE_CLIENT_ID=########-####-####-####-############
export AZURE_SECRET=########################################
export AZURE_TENANT=########-####-####-####-############" | tee ~/azurecreds.sh

chmod +x ~/azurecreds.sh
~/azurecreds.sh

# ---------------------------------------------------------------------------
## dummy single RG test
# ---------------------------------------------------------------------------

## one-liner
ansible localhost -m azure.azcollection.azure_rm_resourcegroup -a "name=ansible-test location=australiaeast"
## playbook
mkdir -p ~/source/learn-ansible/basic-ansible-check
cd ~/source/learn-ansible/basic-ansible-check
## <--- edit files here
ansible-playbook ./basic-ansible-check/create_rg.yml # create
ansible-playbook ./basic-ansible-check/delete_rg.yml # delete / cleanup

# ---------------------------------------------------------------------------
## set up a Windows VM and connect over WinRM
# ---------------------------------------------------------------------------

mkdir -p ~/source/learn-ansible/single-windows-vm-winrm
cd ~/source/learn-ansible/single-windows-vm-winrm
ansible-playbook windows-vm.yml # get the public IP
pip install "pywinrm>=0.2.2" # needed for WinRM connection see https://access.redhat.com/solutions/3356681
ansible-playbook connect-vm.yml -i PUBLICIPADDRESSHERE,
ansible-playbook delete-windows-vm.yml