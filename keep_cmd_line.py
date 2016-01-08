#Get make a multifasta file of seq based on a subset list called "keep_list".
#given:
#seq1
#seq2
#seq3
#pick out the sequences matching this and write to a multi-fasta
#goes from a command line file name to output modifed filename wiht only the keep set in 
#Needs fasta.stuff.py
# C Kidner 8th january 2016

import fasta_stuff
import fileinput

def get_fasta(name):

	seq = file_dict.get(name, "empty")
	fasta = ">" +name + "\n" + seq


	return fasta

keep_output = []
keep_lines_processed = 0
keep_seq_found = 0

for line in fileinput.input():


#Make dicts of the fasta sequences in each file with the fasta-line as the key

	file_dict = fasta_stuff.fasta_dict(fastafile)

	keeplist_file = 'keep_list'

	if keeplist_file != None:
		keeplist = open(keeplist_file)
		for name in keeplist:
			name = name.rstrip("\n")
			keep_lines_processed += 1
		
			print("looking for sequence: " + "\n" + name)
			fasta_seq = get_fasta(name)
			if "empty" in fasta_seq:
				print (str(name) + " is not there!")
			else:
				keep_seq_found +=1
				keep_output.append(fasta_seq)
		
#	print("Keep lines processed = " + str(keep_lines_processed))
#	print("Keep sequences found = " + str(keep_seq_found))
	out_name = "kept_" + str(line)
	outfile = open(out_name, "w")
	outfile.write("\n".join(keep_output))
	outfile.close()
	
			
	
