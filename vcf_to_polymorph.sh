#! /bin/bash -x
# Take a vcf files of accession reads mapped to baits and generate a list of good polymorphisms
# Wokrin with the set of 326 loci which have at least 1kb of sequence - FOr_pop_gene

acc=$1

vcf=${acc}.vcf
1K=1k_${acc}.vcf
poly=${acc}_good_polymorphs.txt

#trim to 1kb each
while read f ; do grep -m 1000 "$f" $vcf >> $1K ; done < For_pop_gen

#Per locus per accession count the polymorphisms from the ref
#loop through loci and accessions with:

while read f ; do grep "$f" $1K | grep "GT:PL:GQ" | grep  :[3-9][0-9]$ >> $poly ; done < For_pop_gen

#Per accession pair pull out the un-shared polymorphisms and count these per locus
#join -v 1 set1_poly set2_poly > dif

#Per accession pair pull out the un-shared polymorphisms and count these per locus
#Per accession pair count how many of the un-shared polymorphisms to ref are heterozygous
#The counts for the shared polymorphisms to ref and the shared heterozygous polymorphism to ref will be calculated

exit 0


