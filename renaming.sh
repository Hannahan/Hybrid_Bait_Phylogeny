# Renaming the files by the folder names, getting them out of the folders
# For dealing with Genepoool output

# In directory with the folders in make a list of folder names, to run through this on a while loop

acc=$1

input=${acc}/*_1*.gz
output= ${acc}_1.fastq.gz

mv $input $output