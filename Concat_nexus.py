''' Concatenate interleaved nexus files into a single interleaved nexus 
cannot cope with missing data.  Assumes if data is missing for a locus for an accession there is a files of Ns replacing it'''

#read in file lists

#nexusfile_list = "nexus_files"
#locus_list_file = "locus_list"

# Read in the seq data to a holding file
# when read "MATRIX": next line is the beginning of the data
# read in until ";" into a string

def get_block(nexus_file):
	new_block = []
	with open(nexus_file) as input_data:
# Skips text before the beginning of the interesting block:
		for line in input_data:
			if line.strip() == 'MATRIX':  # Or whatever test is needed
				break
# Reads text until the end of the block:
		for line in input_data:  # This keeps reading the file
			if line.strip() == ';':
				break
			line = line.rstrip("\n")
			new_block.append(line)
	return(new_block)

# Count the resdidues in the file

def count_bp(block, name):
	counter = ''
	for line in block:
		line = str(line)
		if line.startswith(name):
# clean up line to just nucleotides and append to a counting list
			line = line.lstrip(name)
			line = line.lstrip()
			line = line.rstrip()
			counter = counter + str(line)
	return len(counter) - counter.count(' ')

nexus_list_file = input("Which list of nexus files (full file name please)?\n")
accession_list_file = input("Which file for names of accessions?\n")

#open files for each locus (for reading and writting) ready to feed in the nexuses

if accession_list_file != None:
	acc_list = open(accession_list_file)
	acc_name_list = []
	for name in acc_list:
		name = name.rstrip("\n")
		acc_name_list.append(name)

picked = acc_name_list[0]
n_acc = len(acc_name_list)

print( str(picked))

all_blocks = []

char_block = []

bp_beg = 1

if nexus_list_file != None:
	nexus_file_list = open(nexus_list_file)
	for nexus_file in nexus_file_list:
		nexus_file = nexus_file.rstrip()
		new_block = get_block(nexus_file)
		all_blocks = all_blocks + new_block
		locus_count = count_bp(new_block, picked)
		bp_end = bp_beg + locus_count - 1
		print("Locus count is " + str(locus_count))
		locus_name = nexus_file.rstrip(".nex")
		char_line = "CHARSET " + str(locus_name) + " = " + str(bp_beg) + " - " + str(bp_end) + " ;"
		char_block.append(char_line)
		bp_beg = bp_end + 1
		print("Accumlulated bp is " + str(bp_end))

total_bp = count_bp(all_blocks, picked)
print ("Total_bp is " + str(total_bp))

# rebuild the header

header_1 = "BEGIN DATA;"
header_2 = "DIMENSIONS NTAX=" + str(n_acc) + " NCHAR=" + str(bp_end) + ";"
header_3 = "FORMAT DATATYPE=DNA INTERLEAVE=yes GAP=-;"

header_list = [header_1, header_2, header_3]

acc_data = []
for acc_name in acc_name_list:
	line = "[Name: " + str(acc_name) + "			Len: " + str(bp_end) + " Check: 0]"
	acc_data.append(line)
acc_data.append("")
acc_data.append("MATRIX")

footer_1 = ""
footer_2 =  ";"
footer_3 = "END;"
footer_4 = ""

footer_list = [footer_1, footer_2, footer_3]


char_block.insert(0,"BEGIN SETS;")
char_block.append("END;")

new_nexus_list = header_list + acc_data + all_blocks + footer_list + char_block

new_nexus = '\n'.join(new_nexus_list)

# print (new_nexus)



outfile = open("concat.nex", "w")
for item in new_nexus_list:
  outfile.write("%s\n" % item)








