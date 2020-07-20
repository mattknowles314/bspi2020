#This opens the .txt.gz file ncbi.nlm.nih.giv/geo/query/acc.cgi?acc=GSE32222
dataLocation = "~/Documents/BSPIData/GSE32222_series_matrix.txt.gz" #You will need to change this to the directory your have the file stored in locally
Data = read.table(gzfile(dataLocation),sep="\t",fill=TRUE)

View(Data)
