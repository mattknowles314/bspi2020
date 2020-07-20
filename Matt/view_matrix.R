#This opens the .txt.gz file from 
setwd("~/Documents/matthew/BSPIData")
Data = read.table(gzfile("GSE32222_series_matrix.txt.gz"),sep="\t")
