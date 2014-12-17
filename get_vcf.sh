#! /bin/bash -x
# to take the hyb baits reads listed, bowtie to Inga baits, , convert to bam, make index, pileup and vcf
#Catherine Kidner 28 Oct 2014

echo "Hello world"
acc=$1

index=${acc}_sorted.bam
pileup=${acc}.pileup
vcf=${acc}.vcf


samtools mpileup -E -uf Ref_new.fna  $index > $pileup
bcftools view -cg $pileup > $vcf

rm *pileup


exit 0

