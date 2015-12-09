#! /bin/bash -x
# to go from trimmed H6 seq to consensu bam on iplant
# Needs ck_empties.sh and ck_remove.sh
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 3 Dec 2015


echo "Hello world"

acc=$1
tar=${acc}.tar.gz
F=${acc}_trimmed_1.fastq.gz
R=${acc}_trimmed_2.fastq.gz
Fu=${acc}_trimmed_1u.fastq
Ru=${acc}_trimmed_2u.fastq
bowtie=${acc}_bowtie_output
rc=${acc}_rc.txt
output=${acc}_consensus.fna
vcf=${acc}.vcf

echo "You're working on accession $1"

cp ~/Documents/iROD/$tar ./
tar -zxvf $tar

bowtie2 --local --score-min G,320,8 -x ~/bowtie_index/All_loci -1 $F -2 $R -U $Fu,$Ru -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_loci.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

#get read_counts - reads 125bp long

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=250*$3/$2} {print $1, depth}' | sort > $rc

rm *.sam
rm *.pileup
rm *.bam
rm *.bai
rm *.gz
rm *.fastq

grep -v "INDEL" output.vcf | awk '{if ($6 >= 36) print $0}' > clean.vcf

perl vcfutils_fasta.pl vcf2fq clean.vcf > output.fna

sed '/^[^>]/s/[^ATGCactg]/N/g' output.fna > $output 

cp $vcf vcf_files/

rm *.vcf


exit 0

