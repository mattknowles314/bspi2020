setwd("/home/matthew/Documents/BSPIData/")
library(DiffBind)

samples <- read.csv("labelled_2.csv")
samples_dba <- dba(sampleSheet = "labelled_2.csv")

samples_count<-dba.count(samples_dba, summits=250, bParallel = FALSE)
plot(samples_count)

samples_contrast <- dba.contrast(samples_count, categories = DBA_CONDITION)

sample_analyze <- dba.analyze(samples_contrast)

dba.plotHeatmap(samples_contrast,contrast = 0.2)

samples.DB <- dba.report(sample_analyze)