#! /bin/bash -x
# Renaming the files by the folder names, getting them out of the folders
# For dealing with Genepoool output

# In directory with the folders in make a list of folder names, to run through this on a while loop

acc=$1

input1=${acc}/*_1*.gz
output1=${acc}_1.fastq.gz

input2=${acc}/*_2*.gz
output2=${acc}_2.fastq.gz

mv $input1 $output1
mv $input2 $output2