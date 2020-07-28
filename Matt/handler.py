import os
sraLoc = "/home/matthew/Documents/BSPIData/prefetch_deposits/sra"
fastqLoc = "/home/matthew/Documents/BSPIData/prefetch_deposits/fastq_files"

for gsm in os.listdir(sraLoc):
    os.system("fastq-dump "+sraLoc+"/"+gsm)
