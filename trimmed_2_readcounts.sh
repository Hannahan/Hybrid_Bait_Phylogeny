#! /bin/bash -x
# to go from raw seq to consensu bam from remote
# Needs command line list of calls for server.
# Needs ck_empties.sh and ck_remove.sh
#Catherine Kidner 3 Jul 2015


echo "Hello world"

acc=$1
fwd_p=../trimmed/${acc}_trimmed_1.fastq.gz
rev_p=../trimmed/${acc}_trimmed_2.fastq.gz
un_p=../trimmed/${acc}_trimmed_1u.fastq,../trimmed/${acc}_trimmed_2u.fastq

echo "You're working on accession $1"

call=${acc}.tar.gz

#get raw from server
smbclient //nased05/EvoDevo -U rbg-nt\\ckidner%t@tws2bresych -c cd\ EvoDevo/Hyb_Hiseq_96/ \  ;prompt;mget $call
tar -zxvf $call
bowtie2 --local  --score-min G,130,8 -x ~/bowtie2-2.0.2/All_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz  -S output.sam 2>bowtie_output
#bowtie2 --local  --score-min G,320,8 -x ~/bowtie2-2.0.2/All_baits-1 $fwd_p  -2 $rev_p  -U $un_p  -S $sam   -S output.sam 2>bowtie_output
samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=250*$3/$2} {print $1, depth}' | sort > $acc_rc

rm *.sam
rm *.bam
rm *.gz


exit 0

