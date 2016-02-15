#! /bin/bash -x
# to go from raw seq to consensus on iplant for Flavia
# Assumes files are in form *_1.fastq.gz and are in the folder ~/Documents/iROD/Flavia/
# Assumes you're working in the folder Process - the attached Volume
# Runs as a while loop: 
# Make a list of the accession names:
# make a folder for the vcfs (may want to check these later, but they are large so leave on Process volume instead of iROD):
# mkdir vcf/
# ls ~/iROD/Flavia/*_1.fastq.gz | sed 's/_1\.fastq\.gz//g' > accession_names
# while read f ; do ~/Hybrid_Bait_Phylogeny/raw_to_fasta_Flavia.sh "$f" ; done < accession_names

# Catherine Kidner 10 Feb 2016


echo "Hello world"

acc=$1
F=~/Documents/iROD/Flavia/${acc}_1.fastq.gz
R=~/Documents/iROD/Flavia/${acc}_2.fastq.gz
vcf=${acc}.vcf

output=~/Documents/iROD/Flavia/${acc}_consensus.fna
rc=~/Documents/iROD/Flavia/${acc}_rc.txt
bowtie=~/Documents/iROD/Flavia/${acc}_bowtie_output

echo "You're working on accession $1"

#Trimmomatic
java -jar ~/Documents/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 $F $R forward_paired.fq.gz forward_unpaired.fq.gz reverse_paired.fq.gz reverse_unpaired.fq.gz ILLUMINACLIP:../Trimmomatic-0-0.33/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#cutadapt
#cutadapt -a AGATCGGAAGAGC -o f_paired.fq.gz forward_paired.fq.gz  2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o r_paired.fq.gz reverse_paired.fq.gz 2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o f_unpaired.fq.gz forward_unpaired.fq.gz 2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o r_unpaired.fq.gz reverse_unpaired.fq.gz 2>> cut_out

#remove unpaired
#cat f_paired.fq.gz r_paired.fq.gz | grep -B1 "^$" | grep "^@" | cut -f1 -d " " - > All.empties

#cat r_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 2.fastq.test.gz; mv 2.fastq.test.gz r_paired.fq.gz
#cat f_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 1.fastq.test.gz; mv 1.fastq.test.gz f_paired.fq.gz

bowtie2 --local  --score-min G,320,8 -x ~/bowtie_index/All_loci -1 forward_paired.fq.gz  -2 reverse_paired.fq.gz  -U forward_unpaired.fq.gz,reverse_unpaired.fq.gz  -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_loci.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > $vcf

#get read_counts - reads 125bp long

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=125*$3/$2} {print $1, depth}' | sort > $rc

rm *.sam
rm *.pileup
rm *.bam
rm *.bai
rm *.fq
rm *.gz

grep -v "INDEL" $vcf | awk '{if ($6 >= 36) print $0}' > clean.vcf

perl vcfutils_fasta.pl vcf2fq clean.vcf > output.fna

sed '/^[^>]/s/[^ATGCactg]/N/g' output.fna > $output 

mv $vcf vcf_files/

#rm *.vcf

exit 0

