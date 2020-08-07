setwd("/home/matthew/Documents/BSPIData/")
library(DiffBind)

samples <- read.csv("labelled_2.csv")
samples_dba <- dba(sampleSheet = "labelled_2.csv",minOverlap = 0,config = data.frame(reportInit="DBA", DataType=DBA_DATA_GRANGES, AnalysisMethod=DBA_DESEQ2),peakCaller = "bed",bRemoveM = TRUE, attributes = c(DBA_CONDITION, DBA_TISSUE))

samples_count<-dba.count(samples_dba, summits=350, bParallel = FALSE)
plot(samples_count)

samples_contrast <- dba.contrast(samples_count, categories = c(DBA_CONDITION,DBA_TISSUE))
plot(samples_contrast)

sample_analyze <- dba.analyze(samples_contrast, method=DBA_DESEQ2, bFullLibrarySize=TRUE)
plot(sample_analyze)

dba.plotHeatmap(sample_analyze,contrast = 1)

samples.DB <- dba.report(sample_analyze)
