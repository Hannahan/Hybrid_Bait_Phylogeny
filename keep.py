#Get make a multifasta file of seq based on a subset list.
#given: 
#seq1
#seq2
#seq3
#pick out the sequences matching this and write to a multi-fasta
#Needs fasta.stuff.py

import fasta_stuff

def get_fasta(name):

	seq = file_dict[name]
	fasta = ">" +name + "\n" + seq


	return fasta

keep_output = []
keep_lines_processed = 0
keep_seq_found = 0

fastafile = input("Which fasta file?\n")

#Make dicts of the fasta sequences in each file with the fasta-line as the key

file_dict = fasta_stuff.fasta_dict(fastafile)

keeplist_file = input("Which file for names to keep?\n")

if keeplist_file != None:
	keeplist = open(keeplist_file)
	for name in keeplist:
		name = name.rstrip("\n")
		keep_lines_processed += 1
	
		print("looking for sequence: " + "\n" + name)
		fasta_seq = get_fasta(name)
		if fasta_seq != None:
			keep_seq_found +=1
			keep_output.append(fasta_seq)


print("Keep lines processed = " + str(keep_lines_processed))
print("Keep sequences found = " + str(keep_seq_found))

outfile = open('Kept_set', "w")
outfile.write("\n".join(keep_output))
outfile.close()
	
			
	
