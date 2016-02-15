"""change file names using a list of paried names original new"""


import subprocess
import re

def change_me(name1, name2):
        try:
                my_command = "mv " +str(name1) + "  " + str(name2)
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with mv")



list_file = input("Which file for list of old and new names?\n")
list_file = list_file.rstrip()
list = open(list_file)

#loop through list.
for line in list:
        bits = line.split()
        name1 = bits[0]
        name1 = name1.rstrip() 
        name2 = bits[1]
        name2 = name2.rstrip()
        print ("Trying mv on" + str(name1))
        change_me(name1, name2)
print ("Done with the list")
