setwd("/home/matthew/Documents/BSPIData/")

library(DiffBind)

#Run DiffBind Analysis
samples <- read.csv("labelled_data.csv")
samples_dba <- dba(sampleSheet = samples, config = data.frame(reportInit="DBA", DataType=DBA_TISSUE, AnalysisMethod=DBA_DESEQ2), bRemoveM = TRUE)
samples_count<-dba.count(samples_dba,  bParallel = FALSE)
samples_contrast <- dba.contrast(samples_count, categories = c(DBA_CONDITION,DBA_TISSUE))
samples_analyze <- dba.analyze(samples_count, method=DBA_DESEQ2, bFullLibrarySize=TRUE)
samples.DB <- dba.report(samples_analyze, method = DBA_DESEQ2, bAll = TRUE, bUsePval=TRUE)

#Produce Plots
png(file="~/Documents/BSPIData/plots/pcadata.png")
dba.plotPCA(samples_analyze, DBA_TISSUE, label=DBA_CONDITION)
dev.off()

png(file="~/Documents/BSPIData/plots/madata.png")
dba.plotMA(samples_analyze, bUsePval = TRUE)
dev.off()

png(file="~/Documents/BSPIData/plots/hmpdata.png")
dba.plotHeatmap(samples_analyze, contrast=1, bUsePval = TRUE)
dev.off()

png(file="~/Documents/BSPIData/plots/volcdata.png")
dba.plotVolcano(samples_analyze, bUsePval = TRUE)
dev.off()

png(file="~/Documents/BSPIData/plots/boxdata.png")
dba.plotBox(samples_analyze, bUsePval = 1, contrast = 1)
dev.off()