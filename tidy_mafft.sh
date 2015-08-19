#! /bin/bash -x
# to go from the output of swtich multifastas.py to a tar of the mafft files ready to trimal
#Catherine Kidner 18 Nov 2014


echo "Hello world"

acc=$1

echo "You're working on accession $1"


switched=${acc}.fasta
no_loci_name=${acc}_f.fna
mafft=${acc}_mafft.fasta
fna=${acc}.fna
fasta=${acc}.fasta

sed "s/_$acc//g" $switched > $no_loci_name 
sed "s/[rywsmkdvhb]/n/g" $fna > $fasta
tr '[:lower:]'  '[:upper:]' < $no_loci_name > $fna
rm $no_loci_name
linsi --thread 8 $fasta > $mafft


exit 0
