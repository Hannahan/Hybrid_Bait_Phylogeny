#!/bin/sh
zcat $1_trimmed.1.fastq.gz $1_trimmed.2.fastq.gz | grep -B1 "^$" | grep "^@" | cut -f1 -d " " - > $1.empties
