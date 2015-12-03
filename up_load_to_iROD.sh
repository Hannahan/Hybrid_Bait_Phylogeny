#! /bin/bash -x
# upload files from current folder to iROD

# Catherine Kidner 1 Dec 2015

echo "Hello world"

acc=$1
fwd=${acc}_1.fastq.gz
rev=${acc}_2.fastq.gz

echo "You're working on accession $1"

iput $fwd raw_reads
iput $rev raw_reads

exit 0