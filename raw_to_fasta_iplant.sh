#! /bin/bash -x
# to go from raw seq to consensu bam from remote
# Needs ck_empties.sh and ck_remove.sh
# Needs to renamethe raw files by their accession names wiht the ends _1.sanfastq.zip _2.sanfastq.zip
# Catherine Kidner 21 Oct 2015


echo "Hello world"

acc=$1
F=${acc}_1.sanfastq.gz
R=${acc}_2.sanfastq.gz

echo "You're working on accession $1"

#Trimmomatic
java -jar ~/Documents/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 $F $R forward_paired.fq.gz forward_unpaired.fq.gz reverse_paired.fq.gz reverse_unpaired.fq.gz ILLUMINACLIP:../Trimmomatic-0-0.33/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#cutadapt
cutadapt -a AGATCGGAAGAGC -o f_paired.fq.gz forward_paired.fq.gz  2>> cut_out
cutadapt -a AGATCGGAAGAGC -o r_paired.fq.gz reverse_paired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC -o f_unpaired.fq.gz forward_unpaired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC -o r_unpaired.fq.gz reverse_unpaired.fq.gz 2>> cut_out

#remove unpaired
cat f_paired.fq.gz r_paired.fq.gz | grep -B1 "^$" | grep "^@" | cut -f1 -d " " - > All.empties

cat r_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 2.fastq.test.gz; mv 2.fastq.test.gz r_paired.fq.gz
cat f_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 1.fastq.test.gz; mv 1.fastq.test.gz f_paired.fq.gz

bowtie2 --local  --score-min G,320,8 -x ~/bowtie_index/All_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz  -S output.sam 2>bowtie_output
samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_baits.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

rm *.sam
rm *.pileup


grep -v "INDEL" output.vcf | awk '{if ($6 >= 36) print $0}' > clean.vcf

vcfutils_fasta.pl vcf2fq clean.vcf > consensus.fasta

rm clean.vcf

exit 0

