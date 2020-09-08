#use of count for correcting the GSM/SRR name switch in sra repository is a temporary fix.

#Put this file in the bin of your SRA toolkit!
import os

#Set path to where sra files are stored (use forward slashes)
sra = "./SRA_repository/sra"
#set path to where you want fastq files to be put. (use forward slashes)
out = "./sequences"

#sample_ID = ["GSM798383", "GSM798384", "GSM798385", "GSM798386", "GSM798387", "GSM798388", "GSM798389", "GSM798390", "GSM798391", "GSM798392", "GSM798393", "GSM798394", "GSM798395", "GSM798396", "GSM798397", "GSM798398", "GSM798399", "GSM798400", "GSM798401", "GSM798402", "GSM798403", "GSM798404", "GSM798405", "GSM798406", "GSM798407", "GSM798408", "GSM798409", "GSM798410", "GSM798411", "GSM798412", "GSM798413", "GSM798414", "GSM798415", "GSM798416", "GSM798417", "GSM798418", "GSM798419", "GSM798420", "GSM798421", "GSM798422", "GSM798423", "GSM798424","GSM798425", "GSM798426"
#sample_ID = ["GSM798427", "GSM798428", "GSM798429", "GSM798430", "GSM798431", "GSM798432", "GSM798433", "GSM798434", "GSM798435", "GSM798436", "GSM798437", "GSM798438", "GSM798439", "GSM798440",
#sample_ID = ["GSM798441", "GSM798442", "GSM798443", "GSM798444"]
sample_ID = ["GSM798442", "GSM798444"]
count = 1021804

for ID in sample_ID:
    print("Prefetching {0}...".format(ID))
    os.system("prefetch " + ID)
    count += 2
    print("Dumping {0}...".format(ID))
    os.system("fastq-dump --outdir {0} --split-files {1}/SRR{2}.sra".format(out, sra, count)) 
print("Finished")

