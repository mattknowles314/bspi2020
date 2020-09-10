import os

bamreadsdir = "/home/matthew/Documents/BSPIData/sorted/"

seq_list = ['GSM798385S', 'GSM798392S', 'GSM798393S']

for i in seq_list:
    os.system("macs2 callpeak -t "+bamreadsdir+i+".bam "+"-f BAM -n ~/Documents/BSPIData/peaks/"+i.strip(".bam"))
