#! /bin/bash -x
# to go from the output of swtich multifastas.py to a tar of the mafft files ready to trimal
#Catherine Kidner 18 Nov 2014


echo "Hello world"

acc=$1

echo "You're working on accession $1"


switched=${acc}.fasta
no_loci_name= ${acc}.fna
mafft=${acc}_mafft.fasta
fna=${acc}.fna

sed ’s/‘\_$acc//g’ $switched > $no_loci_name 
linsi --thread 8 $switched > $fna
tr '[:lower:]'  '[:upper:]' < $fna > $mafft


exit 0
