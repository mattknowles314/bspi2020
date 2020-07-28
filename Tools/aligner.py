import os

print('''
                ###############################
                # WELCOME TO THE BWA ALIGNER! #
                ###############################

>This program runs so that you shouldn't need to edit any source code as
    you will be asked for necessary directories during runtime<
>Please report any issues on GitHub and I will endeavour to fix them ASAP<
>Note that this program is simply an interface, it is not responsible for
    any of the actual aligning<
>Happy aligning!<
''')

fastqdir = str(input("Enter your directory of fastq files: "))
bwadir = str(input("Enter your BWA directory: "))
bamdir = str(input("Enter the directory you would like to store the .bam files: "))
os.chdir(bwadir)

for fastq in os.listdir(fastqdir):
    os.system("./bwa mem hs38.fa "+fastqdir+"/"+fastq+" > "+bamdir+"/"+fastq.strip(".fastq")+".bam")

print("##### FINISHED! ######")
