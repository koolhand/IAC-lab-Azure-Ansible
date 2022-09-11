export PROJECT=~/source/learn-ansible
mkdir -p $PROJECT
cd $PROJECT
source $PROJECT/.venv/bin/activate

# ~/azurecreds.sh 
eval "$(awk -F "="  'NR>1 {print "AZURE_" toupper($1) "=" $2}' ~/.azure/credentials)"
