#! /bin/bash -x
# to go from consensus fastas to alignements on iplant
# Need a folder called By_locus, a list of loci called “locus_list” and a list of files called “fasta_files”
# Assumes you have just run python3 switch_multifastas.py and moved to folder By_locus
# Finish by running python3 ~/amas-0.93/amas/AMAS.py -f fasta -d dna -i *fna -c

# Catherine Kidner 3 June 2016

# Replace name of seq with just the accession, convert bases to uppercase, mafft align, strict trim and summarise

acc=$1

echo "You're working on accession $1"

input=${acc}.fasta
mafft=${acc}_mafft.fasta
fasta=${acc}_clean.fasta
strict=~/iROD/Genetic_distance/${acc}_strict.fna
summary=~/iROD/Genetic_distance/${acc}_summary.txt

#Remove the locus names in the headers and clean up non standard char

sed "s/_$acc_consensus.fast//g" $input | sed '/^[^>]/s/[^ATGCactg]/N/g' > $fasta

mafft --auto --thread 1 $fasta > $mafft

# Use trimmal to trim the alignemnts of gappy regions and output as nexus for PAUP

trimal -in $mafft -out $strict -strict 

# use amas to get summary info for each alignment

python ~/amas-0.93/amas/AMAS.py -f fasta -d dna -i $strict -s -o $summary

rm $input
rm $mafft
rm $fasta


exit 0