"""get the trimmed reads from the server,  bowtie, get the read counts and delete the intermediates """
# C Kidner 19th August 2015
 

import subprocess
import re

def call_me(name1):
        try:
                my_command = "smbclient //nased05/EvoDevo -U 'rbg-nt\ckidner%t@tws2bresych' -c 'cd EvoDevo/Hyb_Hiseq_96/  ;prompt;mget "+ str(name1) + ".tar.gz'"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with call")


def bowtie_me(name1):
        try:
                my_command = "bowtie2 —-local --score-min G,130,8 -x ~/bowtie2-2.0.2/All_baits -1 f_paired.fq.gz -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz -S output.sam 2>" +str(name1) + "_bowtie_out"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with bowtie")


def clean_up_reads(name1):
        try:
                my_command = "rm *.gz"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with remove reads")


def clean_up_bams(name1):
        try:
                my_command = "rm *am"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with remove bams and sams")


def sort(name1):
        try:                
                my_command = "samtools view -bS output.sam | samtools sort - bam_sorted"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with bam_sorted")


def get_rc(name1):
        try:                
                my_command = "samtools idxstats bam_sorted.bam |grep -v '^\*' | awk '{ depth=250*$3/$2} {print $1, depth}' | sort > "+str(name)+"_rc.txt"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with get_rc")

def untar(name1):
        try:                
                my_command = "tar -zxvf "+str(name1)+".tar.gz"
                output = subprocess.call(my_command, shell=True, stderr=subprocess.STDOUT)
        except:
                print ("Problems with untar")

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
        untar(name1)
        print ("Trying bowtie on" + str(name1))
        bowtie_me(name1)
        print ("Trying sort on" + str(name1))
        sort(name1)
        print ("Trying get_rc on" + str(name1))
        get_rc(name1)
        print ("Trying clean_up reads on" + str(name1))
        clean_up_reads(name1)
        print ("Trying clean_up bams and sams on" + str(name1))
        clean_up_bams(name1)

print ("Done with the list")
