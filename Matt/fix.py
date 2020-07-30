import os
for line in os.listdir():
    if ".bam" in line:
        os.system("rm "+line)
