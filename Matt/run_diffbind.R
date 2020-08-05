setwd("/home/matthew/Documents/BSPIData/")
library(DiffBind)

samples <- read.csv("labelled_2.csv")
df <- dba(sampleSheet = "labelled_2.csv")
plot(df)
df<-dba.count(df, summits=500)
