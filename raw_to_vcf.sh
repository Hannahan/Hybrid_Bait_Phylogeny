#! /bin/bash -x
# to go from raw seq to vcf on iplant
# Assumes files are in form *_1.fastq.gz and are in the folder ~/Documents/Process/raw_reads
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 15 Dec 2015


echo "Hello world"

acc=$1
tar=${acc}.tar.gz
F=${acc}_trimmed_1.fastq.gz
R=${acc}_trimmed_2.fastq.gz
Fu=${acc}_trimmed_1u.fastq
Ru=${acc}_trimmed_2u.fastq
output=~/Documents/iROD/vcf_for_lyndsey/${acc}.vcf
bowtie=$acc_bowtie_out

echo "You're working on accession $1"

# leaving the from-trimmed here in case I need to change this in future

#get the trimmed tar from raw_reads folder and tidying up the old mess
cp ~/Documents/Process/raw_reads/$tar ./
tar -zxvf $tar

bowtie2 --local  --score-min G,320,8 -x ~/bowtie_index/All_loci -1 $F -2 $R -U $Fu,$Ru -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_loci.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > $output

rm *.sam
rm *.pileup
rm *.bam
rm *.bai
rm *.fq
rm *.gz


exit 0

