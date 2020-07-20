#Based on the DiffBind tutorial, I am playing around with one of the samples from the GEO Acession Viewer

library(DiffBind)
dataLoc = "~/Documents/BSPIData/GSM798438.txt.gz"
samples <- read.table(gzfile(dataLoc),sep="\t",fill=TRUE)
