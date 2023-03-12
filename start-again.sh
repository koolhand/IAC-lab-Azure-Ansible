./start.sh
rm -r -f $PROJECT/.venv
python -m venv $PROJECT/.venv

pip3 install --upgrade --requirement $PROJECT/requirements-dev.txt
pip3 install --upgrade --requirement $PROJECT/requirements.txt

ansible-galaxy collection install azure.azcollection --upgrade
pip3 install --upgrade --requirement ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
