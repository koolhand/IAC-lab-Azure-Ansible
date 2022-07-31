./start.sh
rm -r -f $PROJECT/.venv
python -m venv $PROJECT/.venv

pip3 install --upgrade --requirement $PROJECT/requirements-dev.txt
pip3 install --upgrade --requirement $PROJECT/requirements.txt

## ---------------------------------------------------------------------------
## Ansible Azure requirements
## ---------------------------------------------------------------------------
## v1. from Ansible galaxy - note versions are pinned
ansible-galaxy collection install azure.azcollection --upgrade
pip3 install --upgrade --requirement ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
## ---------------------------------------------------------------------------
## v2. more recent - all
## you could try all like this, but it will fail
## - due to a couple of incompatibilities between Azure Python SDK and Ansible Azure modules
# cut -f 1 -d= ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt | xargs -L1 pip3 install --upgrade
## ---------------------------------------------------------------------------
## v3. more recent - just what you need
## this fails too, Ansible module checks for the job lot to import
# pip3 install --upgrade --requirement $PROJECT/requirements-ansibleazure-mini.txt
## ---------------------------------------------------------------------------
## v4. more recent - just exclude bad
## you maintain your own set, mostly unpinned, just pinning the ones that fail
## - due to API version conflicts between Azure Python SDK and how Ansible Azure modules call
# pip3 install --upgrade --requirement $PROJECT/requirements-ansibleazure-annotated.txt