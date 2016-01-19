#! /bin/bash -x
# to go from raw seq to consensus on iplant
# Assumes files are in form *_1.sanfastq.gz and are in the folder ~/Documents/Process/Inga_baits
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 23 Oct 2015


echo "Hello world"

acc=$1

tar=${acc}.tar.gz
F=${acc}_1.fastq.gz
R=${acc}_2.fastq.gz
vcf=${acc}_clean.vcf

output=~/iROD/done_consensuses/${acc}_consensus.fna
rc=~/iROD/done_consensuses/${acc}_rc.txt
bowtie=~/iROD/done_consensuses/${acc}_bowtie_output

echo "You're working on accession $1"

# leaving the from-trimmed here in case I need to change this in future

get the trimmed tar from iROD folder and tidying up the old mess
cp ~/Process/raw_reads/$tar ./
tar -zxvf $tar

#Trimmomatic
#java -jar ~/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 $F $R forward_paired.fq.gz forward_unpaired.fq.gz reverse_paired.fq.gz reverse_unpaired.fq.gz ILLUMINACLIP:../Trimmomatic-0-0.33/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#cutadapt
#cutadapt -a AGATCGGAAGAGC -o f_paired.fq.gz forward_paired.fq.gz  2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o r_paired.fq.gz reverse_paired.fq.gz 2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o f_unpaired.fq.gz forward_unpaired.fq.gz 2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o r_unpaired.fq.gz reverse_unpaired.fq.gz 2>> cut_out

#remove unpaired
#cat f_paired.fq.gz r_paired.fq.gz | grep -B1 "^$" | grep "^@" | cut -f1 -d " " - > All.empties

#cat r_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 2.fastq.test.gz; mv 2.fastq.test.gz r_paired.fq.gz
#cat f_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 1.fastq.test.gz; mv 1.fastq.test.gz f_paired.fq.gz

bowtie2 --local  --score-min G,320,8 -x ~/bowtie_index/All_loci -1 ${acc}_trimmed_1.fastq  -2 ${acc}_trimmed_2.fastq  -U ${acc}_trimmed_1u.fastq,${acc}_trimmed_2u.fastq  -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_loci.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

#get read_counts - reads 125bp long

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=125*$3/$2} {print $1, depth}' | sort > $rc

rm *.sam
rm *.pileup
rm *.bam
rm *.bai
rm *.fq
rm *.gz

grep -v "INDEL" output.vcf | awk '{if ($6 >= 36) print $0}' > $vcf

perl vcfutils_fasta.pl vcf2fq $vcf > $output

#sed '/^[^>]/s/[^ATGCactg]/N/g' output.fna > $output 

#rm *.vcf

exit 0

