#! /bin/bash -x
# to go from bam to consensus
#Catherine Kidner 6 Aug 2015


echo "Hello world"

acc=$1

echo "You're working on accession $1"

out=${acc}_consensus.fasta

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf total_gene_selection.fna  bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

#rm *.sam
#rm *.pileup
#rm *.bam
#rm *.bai


grep -v "INDEL" output.vcf | awk '{if ($6 >= 36) print $0}' > clean.vcf

vcfutils_fasta.pl vcf2fq clean.vcf > $out

rm *.vcf

exit 0

