import os

bamreadsdir = "/home/matthew/Documents/BSPIData/sorted/"

controlsf = open("/home/matthew/Documents/BSPIData/controls.txt","r")
samples = []
controls = []
for i in controlsf:
    x = i.split(",")
    samples.append(x[0])
    controls.append(x[1].strip("\n"))
p = len(samples)-1
i = 0
while i<=p:
    sample = "GSM798"+str(samples[i])+"S.bam"
    control = "GSM798"+str(controls[i])+"S.bam"
    print("-----STARTING CALLPEAK FOR "+sample.upper()+"-----")
    os.system("macs2 callpeak -t "+bamreadsdir+sample+" -c "+bamreadsdir+control+" -f BAM -g hs -n ~/Documents/BSPIData/peaks/"+sample.strip(".bam")+" -B -q 0.01")
    print("-----FINISHED CALLPEAK FOR "+sample.upper()+"-----")
    print("PROGRESS: "+str((i/p)*100))
    i+=1
