import os
import datetime

print('''
###########################
#                         #
# ANALYSIS PIPELINE V1.0  #
#                         #
###########################
''')

'''
This is where you should put the locations of all your rscripts, as well as the report
document if you wish to use that feature
'''
run_diffbind_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/run_diffbind.R"
run_vulcan_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/run_vulcan.R"
db_test_loc = "/home/matthew/Documents/BSPI/Matt/rscripts/testdb.R"
rdata_loc = "/home/matthew/Documents/BSPIData/rdata"
rplot_loc = "/home/matthew/Documents/BSPIData/plots"
report_loc = "/home/matthew/Documents/BSPI/Matt/reports/results.tex"

'''
This is the actual pipeline, to give an overview, this is what it does:
    1. Run DiffBind to generate a dba object and a counts data object
    2. Run a test on those objects to make sure that they will work in vulcan
        2.1 If the test is passed, run vulcan on the objects
            2.1.1 Compile LaTeX file which calls the plots made by DB and vulcan, and output this to a PDF
        2.2 If the test fails, raise an error and terminate the program
'''

print('''
    ####################
    # RUNNING DIFFBIND #
    ####################
        ''')

os.system("Rscript "+run_diffbind_loc)
dataFiles = []
plotFIles = []
plotCount = 0
dataCount = 0
for i in os.listdir(rdata_loc):
    dataCount+=1
for i in os.listdir(rplot_loc):
    plotCount+=1

print("##################################################")
print("# DiffBind produced "+str(dataCount)+" R objects #")
print("# DiffBind produced "+str(plotCount)+" Plots     #")
print("##################################################")
print('''
        ############################
        # TESTING DIFFBIND OBJECTS #
        ############################
        ''')
if(os.system("Rscript "+db_test_loc)==0):
    print('''
            ##################
            # RUNNING VULCAN #
            ##################
            ''')
    os.system("Rscript "+run_vulcan_loc)
    os.system("pdflatex "+report_loc)
    print('''
            #################################
            # PROGRAM FINISHED SUCCESSFULLY #
            #################################
            ''')
else:
    print('''
            ####################################
            # PROGRAM TERMINATED DUE TO ERRORS #
            ####################################
        ''')
