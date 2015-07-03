#! /bin/bash -x
# to go from raw seq to consensu bam from remote
# Needs ck_empties.sh and ck_remove.sh
#Catherine Kidner 3 Jul 2015


echo "Hello world"

acc=$1

echo "You're working on accession $1"

call=${acc}

#get raw from server
smbclient //nased05/EvoDevo -U rbg-nt\\ckidner%t@tws2bresych -c "$call"


#Trimmomatic
java -jar ~/Trimmomatic/Trimmomatic-0.30/trimmomatic-0.30.jar PE -phred33 *_1.sanfastq.gz *_2.sanfastq.gz forward_paired.fq.gz forward_unpaired.fq.gz reverse_paired.fq.gz reverse_unpaired.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36


#cutadapt
cutadapt -a AGATCGGAAGAGC forward_paired.fq.gz > f_paired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC reverse_paired.fq.gz > r_paired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC forward_unpaired.fq.gz > f_unpaired.fq.gz 2>> cut_out
cutadapt -a AGATCGGAAGAGC reverse_unpaired.fq.gz > r_unpaired.fq.gz 2>> cut_out
./ck_empties_fastq.sh $acc
./ck_remove_fastq.sh $acc

sam=${acc}.sam
index=${acc}_sorted.bam
pileup=${acc}.pileup
vcf=${acc}.vcf
bowtie=${acc}_bowtie_output
sorted=${acc}_sorted

bowtie2 --local --score-min $score -x ~/bowtie2-2.0.2/Inga_unique_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz  -S output.sam 2>bowtie_output
samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf Ref_new.fna  bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

rm *.sam
rm *.pileup


grep -v "INDEL" output.vcf | awk '{if ($6 >= 36) print $0}' > clean.vcf

vcfutils_fasta.pl vcf2fq clean.vcf > consensus.fasta

rm clean.vcf

exit 0

