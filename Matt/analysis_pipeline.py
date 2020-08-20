import os
import datetime

run_diffbind_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/run_diffbind.R"
run_vulcan_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/run_vulcan.R"
db_test_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/testdb.R"
rdata_loc = "/home/matthew/Documents/BSPIData/rdata"
rplot_loc = "/home/matthew/Documents/BSPIData/plots"
report_loc = "/home/matthew/Documents/BSPI/Matt/reports/results.tex"


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
print("---RUNNING DIFFBIND TEST---")
if(os.system("Rscript "+db_test_loc)==0):
    print("---RUNNING VULCAN---")
    os.system("Rscripti "+run_vulcan_loc)
    os.system("pdflatex "+report_loc)
    os.system("zathura "+report_loc.strip("tex")+"pdf")
    print("---FINISHED---")
else:
    print("---FAILED---")
