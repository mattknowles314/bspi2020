import os
sraLoc = "/home/matthew/Documents/BSPIData/prefetch_deposits/sra"
fastqLoc = "/home/matthew/Documents/BSPIData/prefetch_deposits/fastq_files"
wd = "/home/matthew/Documents/BSPI/Matt"

for x in os.listdir(wd):
    if ".fastq" in x:
        os.system("mv "+x+" "+fastqLoc)
