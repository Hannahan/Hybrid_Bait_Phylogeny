#! /bin/bash -x
# to go from trimmed H6 seq to consensu bam on iplant
# Needs ck_empties.sh and ck_remove.sh
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 23 Oct 2015


echo "Hello world"

acc=$1
tar=${acc}.tar.gz
F=${acc}_1.sanfastq.gz
R=${acc}_2.sanfastq.gz
bowtie=${acc}_bowtie_output
rc=${acc}_rc.txt
output=${acc}_consensus.fna

echo "You're working on accession $1"


#get the trimmed tar from iROD folder and tidying up the old mess
cp ~/Documents/iROD/Inga_Baits/$tar ./
tar -zxvf $tar

rm forward*
rm reverse*

mv f_unpaired.fq.gz f_unpaired.fq
mv r_unpaired.fq.gz r_unpaired.fq

# leaving the trimming here in case I need to change this to work on the raw reads in future

#Trimmomatic
#java -jar ~/Documents/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 $F $R forward_paired.fq.gz forward_unpaired.fq.gz reverse_paired.fq.gz reverse_unpaired.fq.gz ILLUMINACLIP:../Trimmomatic-0-0.33/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#cutadapt
#cutadapt -a AGATCGGAAGAGC -o f_paired.fq.gz forward_paired.fq.gz  2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o r_paired.fq.gz reverse_paired.fq.gz 2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o f_unpaired.fq.gz forward_unpaired.fq.gz 2>> cut_out
#cutadapt -a AGATCGGAAGAGC -o r_unpaired.fq.gz reverse_unpaired.fq.gz 2>> cut_out

#remove unpaired
#cat f_paired.fq.gz r_paired.fq.gz | grep -B1 "^$" | grep "^@" | cut -f1 -d " " - > All.empties

#cat r_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 2.fastq.test.gz; mv 2.fastq.test.gz r_paired.fq.gz
#cat f_paired.fq.gz | paste - - - - | grep -F -v -w -f All.empties - | tr "\t" "\n" | gzip > 1.fastq.test.gz; mv 1.fastq.test.gz f_paired.fq.gz

bowtie2 --local  --score-min G,130,8 -x ~/bowtie_index/All_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq,r_unpaired.fq  -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_baits.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

#get read_counts - reads 125bp long

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=125*$3/$2} {print $1, depth}' | sort > $rc

rm *.sam
rm *.pileup
rm *.bam
rm *.bai
rm *.gz
rm *.fq

grep -v "INDEL" output.vcf | awk '{if ($6 >= 36) print $0}' > clean.vcf

perl vcfutils_fasta.pl vcf2fq clean.vcf > output.fna

sed '/^[^>]/s/[^ATGCactg]/N/g' output.fna > $output 

#rm clean.vcf
#rm *.gz
#rm *.fq


exit 0

