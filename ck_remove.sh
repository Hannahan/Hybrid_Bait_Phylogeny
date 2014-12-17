#!/usr/bin/env bash
zcat $1_trimmed.2.fastq.gz | paste - - - - | grep -F -v -w -f $1.empties - | tr "\t" "\n" | gzip > $1_2.fastq.test.gz; mv $1_2.fastq.test.gz $1_trimmed.2.fastq.gz
zcat $1_trimmed.1.fastq.gz | paste - - - - | grep -F -v -w -f $1.empties - | tr "\t" "\n" | gzip > $1_1.fastq.test.gz; mv $1_1.fastq.test.gz $1_trimmed.1.fastq.gz
