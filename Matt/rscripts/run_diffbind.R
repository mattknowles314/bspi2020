setwd("/home/matthew/Documents/BSPIData/")

library(DiffBind)

#Run DiffBind Analysis
samples <- read.csv("labelled_2.csv")
samples_dba <- dba(sampleSheet = samples, config = data.frame(reportInit="DBA", DataType=DBA_TISSUE, AnalysisMethod=DBA_DESEQ2),peakCaller = "bed",bRemoveM = TRUE)
samples_count<-dba.count(samples_dba, bParallel = FALSE)
samples_contrast <- dba.contrast(samples_count, categories = c(DBA_CONDITION,DBA_TISSUE))
samples_analyze <- dba.analyze(samples_contrast, method=DBA_DESEQ2, bFullLibrarySize=TRUE)
samples.DB <- dba.report(samples_analyze)

#Produce Plots
png(file="~/Documents/BSPIData/plots/pca.png")
dba.plotPCA(samples_analyze, DBA_TISSUE, label=DBA_CONDITION)
dev.off()

png(file="~/Documents/BSPIData/plots/ma.png")
dba.plotMA(samples_analyze)
dev.off()

png(file="~/Documents/BSPIData.plots.hmp.png")
dba.plotHeatmap(samples_analyze, contrast=1, correlations=FALSE )
dev.off()
