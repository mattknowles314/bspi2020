'''
#########################
# WELCOME TO GSMVIEWER! #
#########################

---INTRODUCTION---

This Python file allows you to do some work with individual GSM files.
The motivation behind this is that I wanted to get a feel for the GSM files, and so what better way
than to play around with them. For that reason I wrote this in Python because when dealing with
unknown data I am more comfortable with this than with R. 

---USAGE---

Have a GSM file you want to get a quick peek at? Look no further, simply put the name of the file
in gsm_code and the folder you store the file in in gsm_location.

Next, pick a chromosome (make sure the file actually contains the paticular chromosome you are after),
then sit back, relax, and enjoy the graphs!

'''

import os
import gzip
import matplotlib.pyplot as plt
import numpy

gsm_code = str(input("Enter GSM Code>> ")).upper()
gsm_location = "../../BSPIData/"+gsm_code+".txt.gz"

chromosome = str(input("Enter Chromosome: "))  #BUG: IF YOU PUT IN 1 OR 2, YOU WILL ALSO GET 11,12,13,ETC I WILL FIX THIS SOON

chrome = []
gsm = gzip.open(gsm_location,mode="rt")
for i in gsm.readlines():
    if i[0:5] == ("chr"+chromosome):
        chrome.append(i)

#Now we have out Chromosme, we need to split the strings into a list 

peak_values = []
start_point = []
end_point = []
midpoints = []
for i in chrome:
    temp_data = i.split()
    peak_values.append(int(temp_data[4]))
    start_point.append(temp_data[1])
    end_point.append(temp_data[2])
    midpoints.append(0.5*(int(temp_data[1])+int(temp_data[2])))


filename = gsm_code+chromosome+".png"
plt.scatter(midpoints, peak_values)
plt.xlabel('Poisition on Chromosome')
plt.ylabel('Peak value')
plt.savefig("BEDPlots/"+filename)
os.system("xdg-open BEDPlots/"+filename) #If you get an error here, replace xdg-open with 'start'
