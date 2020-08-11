setwd("/home/matthew/Documents/BSPIData/")

library(DiffBind, quietly=TRUE)

analysis <- function(){
    samples <- read.csv("labelled_data.csv")
    samples_dba <- dba(sampleSheet = samples, minOverlap = 2, config = data.frame(reportInit="DBA", AnalysisMethod=DBA_DESEQ2), bRemoveM = TRUE)
    save(samples_dba, file = "samplesdba.Rdata")
    samples_count<-dba.count(samples_dba,  bParallel = FALSE)
    save(samples_count, file = "samplescount.Rdata")
    samples_contrast <- dba.contrast(samples_count, categories = c(DBA_CONDITION,DBA_TISSUE))
    save(samples_contrast, file = "samplescont.Rdata")
    samples_analyze <- dba.analyze(samples_count, method=DBA_DESEQ2, bParallel= FALSE)
    save(samples_analyze, file = "samplesanalyze.Rdata")
    samples.DB <- dba.report(samples_analyze, method = DBA_DESEQ2, bUsePval=TRUE, th=0.04)
    save(samples.DB, file = "samplesDB.Rdata")
}

plots <- function(samples_analyze)
{    
    png(file="~/Documents/BSPIData/plots/pcadata.png")
    dba.plotPCA(samples_analyze, DBA_TISSUE, label=DBA_CONDITION, b3D = FALSE)
    dev.off()

    png(file="~/Documents/BSPIData/plots/madata.png")
    dba.plotMA(samples_analyze, bUsePval = FALSE, th=0.04)
    dev.off()

    png(file="~/Documents/BSPIData/plots/hmpdata.png")
    dba.plotHeatmap(samples_analyze, contrast=1, bUsePval = FALSE)
    dev.off()

    png(file="~/Documents/BSPIData/plots/volcdata.png")
    dba.plotVolcano(samples_analyze, bUsePval = TRUE)
    dev.off()

    png(file="~/Documents/BSPIData/plots/boxdata.png")
    dba.plotBox(samples_analyze, notch = FALSE, attribute = DBA_CONDITION, method = DBA_DESEQ2, bAll = TRUE)
    dev.off()
}

load_files <- function(){
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescont.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesDB.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesdba.Rdata")
}
