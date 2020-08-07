import os

bamdir = "/home/matthew/Documents/BSPIData/prefetch_deposits/bam"
os.chdir(bamdir)
for bam in os.listdir(bamdir):
    sortedBam = bam.strip(".bam")+"S.bam"
    os.system("samtools sort "+bam+" > "+sortedBam)
    os.system("samtools index "+sortedBam)
