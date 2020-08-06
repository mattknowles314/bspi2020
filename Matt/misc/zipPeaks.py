import os
os.chdir("/home/matthew/Documents/BSPIData/peaks")
for x in os.listdir():
    if "summits.bed.gz" not in x:
        os.system("rm "+x)
