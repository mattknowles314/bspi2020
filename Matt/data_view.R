library(GEOquery) #This library gives useful functions to access the data
dataLocation = "~/Documents/BSPIData/GSE32222_family.soft.gz" #Replace with where you saved the .soft.gz file
gse32222 <- getGEO(filename=dataLocation) #Read in the data!

