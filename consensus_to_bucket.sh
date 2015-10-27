#! /bin/bash -x
# to go from consensus fastas to alignements on iplant
# Need a folder called By_locus, a list of loci called “locus_list” and a list of files called “fasta_files”
# Assumes you have just run python3 switch_multifastas.py and moved to folder By_locus
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 27 Oct 2015



# Replace name of seq with just the accession, convert bases to uppercase, mafft align

acc=$1

echo "You're working on accession $1"


switched=${acc}.fasta
no_loci_name=${acc}_f.fna
mafft=${acc}_mafft.fasta
fna=${acc}.fna
fasta=${acc}.fasta

sed "s/_$acc//g" $switched > $no_loci_name 
sed "s/[rywsmkdvhb]/n/g" $no_loci_name  > $fna
tr '[:lower:]'  '[:upper:]' < $fna > $fasta
rm $no_loci_name
rm $fna
linsi --thread 8 $fasta > $mafft

# Use trimmal to trim the alignemnts of gappy regions and output as nexus for PAUP

while read f ; 
do 

trimal -in "$f"_mafft.fna -out "$f"_strict_trimmed.nex -strict -nexus ; 

done < locus_list


exit 0