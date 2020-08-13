import os

run_diffbind_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/run_diffbind.R"
run_vulcan_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/run_vulcan.r"
rdata_loc = "/home/matthew/Documents/BSPIData/rdata"
rplot_loc = "/home/matthew/Documents/BSPIData/plots"

print("---RUNNING DIFFBIND---")
os.system("Rscript "+run_diffbind_loc)
dataFiles = []
plotFIles = []
plotCount = 0
dataCount = 0
for i in os.listdir(rdata_loc):
    dataCount+=1
for i in os.listdir(rplot_loc):
    plotCount+=1

print("DiffBind produced "+str(dataCount)+" R objects")
print("DiffBind produced "+str(plotCount)+" Plots")

print("---END OF DIFFBIND---")
print("---RUNNING VULCAN---")
os.system("Rscript "+run_vulcan_loc)