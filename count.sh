#! /bin/bash -x

vcf=$1 
in=${vcf}.vcf
count=${vcf}_count
out=${vcf}_count.txt

while read f ; do grep -c "$f" $in >> $count ; done < picked_loci
paste picked_loci $count | sort -n -k2 > $out
