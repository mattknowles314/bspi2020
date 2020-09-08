setwd("/home/matthew/Documents/BSPIData/")

library(DiffBind)

db_analysis <- function(){
    message("---RUNNING DIFFBIND ANALYSIS---")
    samples_dba <- dba(sampleSheet = "labelled_data.csv", config = data.frame(reportInit="DBA", AnalysisMethod=DBA_DESEQ2, DataType=DBA_DATA_GRANGES), bRemoveM=TRUE)
    samples_count<-dba.count(samples_dba, bParallel = FALSE)
    samples_contrast <- dba.contrast(samples_count, categories = c(DBA_CONDITION,DBA_TISSUE))
    samples_analyze <- dba.analyze(samples_count, method=DBA_DESEQ2, bParallel= FALSE)
    samples_peaks <- dba.peakset(samples_analyze)
    samples.DB <- dba.report(samples_analyze, method = DBA_DESEQ2, bUsePval=TRUE, th=0.05)
    message("---DIFFIBIND COMPLETED: SAVING FILES---")
    save(samples.DB, file = "rdata/samplesDB.Rdata")
    save(samples_dba, file = "rdata/samplesdba.Rdata")
    save(samples_count, file = "rdata/samplescount.Rdata")
    save(samples_contrast, file = "rdata/samplescont.Rdata")
    save(samples_peaks, file="rdata/samplespeaks.Rdata")
    save(samples_analyze, file = "rdata/samplesanalyze.Rdata")
}

make_plots <- function()
{    
    message("---CREATING PLOTS---")
    load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
    png(file="~/Documents/BSPIData/plots/pcadata.png")
    dba.plotPCA(samples_analyze, DBA_TISSUE, label=DBA_CONDITION, b3D = FALSE)
    dev.off()

    png(file="~/Documents/BSPIData/plots/madatarvnr.png")
    dba.plotMA(samples_analyze, contrast = 1,bUsePval = FALSE, th=0.05)
    dev.off()

    png(file="~/Documents/BSPIData/plots/madatarvm.png")
    dba.plotMA(samples_analyze, contrast = 2,bUsePval = FALSE, th=0.05)
    dev.off()

    png(file="~/Documents/BSPIData/plots/madatanrvm.png")
    dba.plotMA(samples_analyze, contrast = 3,bUsePval = FALSE, th=0.05)
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
  message("---LOADING FILES---")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescont.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesDB.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesdba.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplespeaks.Rdata")
}

db_analysis()
make_plots()
