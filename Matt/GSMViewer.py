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
in gsm_code (don't forget the .txt.gz extension!) and the folder you store the file in in gsm_location.

Next, pick a chromosome (make sure the file actually contains the paticular chromosome you are after),
then sit back, relax, and enjoy the graphs!

'''

import gzip
import matplotlib.pyplot as plt
import numpy

gsm_code = "GSM798400.txt.gz"
gsm_location = "../../BSPIData/"+gsm_code

chromosome = "9" #BUG: IF YOU PUT IN 1 OR 2, YOU WILL ALSO GET 11,12,13,ETC I WILL FIX THIS ASAP

chrome = []
gsm = gzip.open(gsm_location,mode="rt")
for i in gsm.readlines():
    if i[0:4] == ("chr"+chromosome):
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

plt.plot(midpoints, peak_values)
plt.xlabel('Poisition on Chromosome')
plt.ylabel('Peak value')
plt.savefig('graph.png')
