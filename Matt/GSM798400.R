dataLocation = "~/Documents/BSPIData/GSM798400.txt.gz"
Data = read.table(gzfile(dataLocation),sep="\t",fill=TRUE)
