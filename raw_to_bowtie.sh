#! /bin/bash -x
# to go from raw seq to consensu bam from remote
# Needs ck_empties.sh and ck_remove.sh
#Catherine Kidner 27 Nov 2015


echo "Hello world"

acc=$1
tar=${acc}.tar.gz
F=~/Documents/iROD/Inga_Baits/${acc}_1.sanfastq.gz
R=~/Documents/iROD/Inga_Baits/${acc}_2.sanfastq.gz

echo "You're working on accession $1"

#Trimmomatic
java -jar ~/Documents/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 $F $R forward_paired.fq.gz forward_unpaired.fq.gz reverse_paired.fq.gz reverse_unpaired.fq.gz ILLUMINACLIP:../Trimmomatic-0-0.33/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

cutadapt
cutadapt -a AGATCGGAAGAGC -o f_paired.fq.gz forward_paired.fq.gz  2>> cut_out
cutadapt -a AGATCGGAAGAGC -o r_paired.fq.gz reverse_paired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC -o f_unpaired.fq.gz forward_unpaired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC -o r_unpaired.fq.gz reverse_unpaired.fq.gz 2>> cut_out

#remove unpaired
cat forward_paired.fq.gz reverse_paired.fq.gz | grep -B1 "^$" | grep "^@" | cut -f1 -d " " - > All.empties

cat reverse_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 2.fastq.test.gz; mv 2.fastq.test.gz reverse_paired.fq.gz
cat forward_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 1.fastq.test.gz; mv 1.fastq.test.gz forward_paired.fq.gz

bowtie2 --local  -x ~/bowtie_index/All_baits -1 forward_paired.fq.gz  -2 reverse_paired.fq.gz  -U forward_unpaired.fq.gz,reverse_unpaired.fq.gz  -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam

#get read_counts - reads 150bp long

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=125*$3/$2} {print $1, depth}' | sort > $rc
