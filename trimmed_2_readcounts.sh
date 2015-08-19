#! /bin/bash -x
# to go from raw seq to consensu bam from remote
# Needs command line list of calls for server.
# Needs ck_empties.sh and ck_remove.sh
#Catherine Kidner 3 Jul 2015


echo "Hello world"

acc=$1

echo "You're working on accession $1"

call=EvoDevo/Hyb_Hiseq_96/${acc}.tar.gz

#get raw from server
smbclient //nased05/EvoDevo -U rbg-nt\\ckidner%t@tws2bresych -c cd\ "$call"

bowtie2 --local  --score-min G,320,8 -x ~/bowtie2-2.0.2/All_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz  -S output.sam 2>bowtie_output
samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=250*$3/$2} {print $1, depth}' | sort > $acc_rc

rm *.sam
rm *.bam
rm *.pileup


exit 0

