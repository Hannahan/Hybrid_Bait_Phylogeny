#! /bin/bash -x
# to take the hyb baits reads listed, bowtie to Inga baits, , convert to bam, make index, pileup and vcf
#Catherine Kidner 28 Oct 2014

echo "Hello world"
echo -n "Which accession would you like to run through from reads to vcf?  Type just the accession name  "
read acc
echo "You picked to work with: $acc  "
echo -n "which starting intercept would you like to use?  "
read n1
echo -n "Which intercept would you like to end with?  "
read n2
echo -n "Which step would you like to take?  Make sure this is divisible into the interval between starting and ending intercept values  "
read step

intercept=$n1

while [ $intercept -le $n2 ]

score=G,${intercept},8
fwd_p=${acc}_forward_paired.fq.gz
rev_p=${acc}_reverse_paired.fq.gz
un_p=${acc}_forward_unpaired.fq.gz,${acc}_reverse_unpaired.fq.gz
sam=${acc}.sam
index=${acc}_${intercept}_sorted.bam
pileup=${acc}_${intercept}.pileup
vcf=${acc}_${intercept}.vcf
bowtie=${acc}_${intercept}_bowtie_output
sorted=${acc}_${intercept}_sorted


do

bowtie2 --local --score-min $score -x ~/bowtie2-2.0.2/Inga_full_baits -1 $fwd_p  -2 $rev_p  -U $un_p  -S $sam 2>$bowtie
samtools view -bS $sam | samtools sort - $sorted
samtools index $index
samtools mpileup -E -uf Ref.fna  $index > $pileup
bcftools view -cg $pileup > $vcf
rm *.sam
intercept=$(($intercept + $step))

done

exit 0

