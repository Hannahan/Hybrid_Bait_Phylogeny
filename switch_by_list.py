'''switch a list of names in a  file'''


target_file = input("Which file to make changes in?")
swaps_file = input("Which file for pairs of names (original {tab} new)?")

if target_file != None:
    text = open(target_file, 'r').read()

if swaps_file != None:
    swaps_list = open(swaps_file)

for pair in swaps_list:
    bits = pair.split()
    original = bits[0]
    replacement = bits[1]

    text = text.replace(str(original), str(replacement))

filename = input("What will be the name of the new file? ")
filename = filename.rstrip('\n')
print ("Opening file named " + filename)
outfile = open(filename, "w")
outfile.write(text)
outfile.close()