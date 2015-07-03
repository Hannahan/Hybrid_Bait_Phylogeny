#! /bin/bash -x
# to fastQC the raw files from the EvoDevo server
#Catherine Kidner 3 July 2015


echo "Hello world"

acc=$1

echo "You're working on accession $1"


call=get EvoDevo/Hyb_Hiseq_96/raw_reads/${acc}

smbclient //nased05/EvoDevo -U rbg-nt\\ckidner%password -c ''call''
fastqc *.gz
rm *.gz



exit 0