"""get the raw reads from the server, trim them, bowtie, and return the trimmed reads to an easy-to-call state """
# C Kidner 3rd August 2015


import subprocess
import re

def call_me(name1):
        try:
                my_command = "smbclient //nased05/EvoDevo -U 'rbg-nt\ckidner%t@tws2bresych' -c 'cd EvoDevo/Hyb_Hiseq_96/raw_reads/" +str(name1) + "\  ;prompt;mget *.gz'"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with call")


def trim_me(name1):
        try:
                my_command = "./trim.sh " +str(name1)
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with trim")


def bowtie_me(name1):
        try:
                my_command = "bowtie2 --local -x ~/bowtie2-2.0.2/All_baits -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz 2>>" +str(name1) + "_bowtie_out"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with bowtie")


def tar_me(name1):
        try:
                my_command = "tar -zcvf " + str(name1) + ".tar.gz *.fq.gz"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with re_name")


def return_me(name1):
        try:
                my_command = "smbclient //nased05/EvoDevo -U 'rbg-nt\ckidner%t@tws2bresych' -c 'cd EvoDevo/Hyb_Hiseq_96/ ;prompt;put " + str(name1) + ".tar.gz'"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with tar")


def clean_up(name1):
        try:
                my_command = "rm *.gz"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with return")



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
        print ("Trying trim on" + str(name1))
        trim_me(name1)
        print ("Trying bowtie on" + str(name1))
        bowtie_me(name1)
        print ("Trying tar on" + str(name1))
        tar_me(name1)
        print ("Trying return on" + str(name1))
        return_me(name1)
        print ("Trying clean_up on" + str(name1))
        clean_up(name1)

print ("Done with the list")
