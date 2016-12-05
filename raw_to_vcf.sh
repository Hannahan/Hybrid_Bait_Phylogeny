#! /bin/bash -x
# to go from raw seq to vcf on iplant
# Assumes files are in form *_1.fastq.gz and are in the folder ~/Documents/Process/raw_reads
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 15 Dec 2015


echo "Hello world"

acc=$1
source_1=~/Process/raw_reads/${acc}_1.fastq.gz
source_2=~/Process/raw_reads/${acc}_1.fastq.gz
F=${acc}_1.fastq.gz
R=${acc}_2.fastq.gz

output=~/Documents/iROD/vcf_for_lyndsey/${acc}.vcf
bowtie=${acc}_bowtie_out

echo "You're working on accession $1"

# leaving the from-trimmed here in case I need to change this in future

#get the trimmed tar from Process (the attched Volume) and tidying up the old mess
cp $source_1 ./
cp $source_2 ./

java -jar ~/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 $F $R f_prd.fq.gz f_uprd.fq.gz r_prd.fq.gz r_uprd.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

bowtie2 --local  --score-min G,320,8 -x ~/bowtie_index/All_loci -1 f_prd.fq -2 r_prd.fq.gz -U f_uprd.fq.gz,r_uprd.fq.gz -S output.sam 2>$bowtie

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

