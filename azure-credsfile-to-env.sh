eval "$(awk -F "="  'NR>1 {print "AZURE_" toupper($1) "=" $2}' ~/.azure/credentials)"