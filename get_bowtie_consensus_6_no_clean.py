"""get the trimmed reads from the server, bowtie to all baits, call the consensus, clean adn remove the bam,sa, and seq files. """
# C Kidner 3rd August 2015


import subprocess
import re

def call_me(name1):
        try:
                my_command = "smbclient //nased05/EvoDevo -U 'rbg-nt\ckidner%t@tws2bresych' -c 'cd EvoDevo/Hyb_Hiseq_96/  ;prompt;mget " + str(name1) + ".tar.gz'"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with call")


def bowtie_me(name1):
        try:
                my_command = "bowtie2 --local --score-min G,130,8 -x ~/bowtie2-2.0.2/All_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz -S "+ str(name1)+".sam 2>>" +str(name1) + "_bowtie_out"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with bowtie")


def untar_me(name1):
        try:
                my_command = "tar -zxvf " + str(name1) + ".tar.gz "
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with un_tar")


def return_me(name1):
        try:
                my_command = "smbclient //nased05/EvoDevo -U 'rbg-nt\ckidner%t@tws2bresych' -c 'cd EvoDevo/Inga_Hyb_trimmed/ ;prompt;put " + str(name1) + ".tar.gz'"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with return")


def clean_up(name1):
        try:
                my_command = "rm *.gz"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with clean up seqs")

def consensus_me(name1):
        try:
                my_command = "./bam_to_consensus " + str(name1)
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with consensus")



list_file = input("Which file for list accessions to process?\n")
list_file = list_file.rstrip()
list = open(list_file)

#loop through list.
for line in list:
        bits = line.split()
        name1 = bits[0]
        name1 = name1.rstrip()
        print ("Trying call on" + str(name1))
        call_me(name1)
        print ("Trying untar on" + str(name1))
        untar_me(name1)
        print ("Trying bowtie on" + str(name1))
        bowtie_me(name1)
        print ("Trying consensus on" + str(name1))
        consensus_me(name1)
        

print ("Done with the list")
