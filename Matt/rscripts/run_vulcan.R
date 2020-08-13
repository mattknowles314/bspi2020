setwd("/home/matthew/Documents/BSPIData/")

library(vulcan)
library(DiffBind)

load_files <- function(){
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescont.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesDB.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesdba.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplespeaks.Rdata")
}

#IMPORT - This replaces vulcan.import

sheet <- read.csv("labelled_data.csv", as.is = TRUE)
dbobj <- samples_dba
message("Sheet loaded. You have ", nrow(sheet), " samples and ", 
          length(unique(sheet$Condition)), " conditions")
dbcounts <- samples_count
listcounts <- dbcounts$peaks
samplenums = c(dbcounts$samples[1])
i = 0
while(i<=19){
  names(listcounts)[i] <- samplenums[["SampleID"]][i]
  i = i+1
}
first <- listcounts[[1]]
rawmat <- matrix(NA, nrow = nrow(first), ncol = length(listcounts) + 
                     3)
colnames(rawmat) <- c("Chr", "Start", "End", names(listcounts))
rownames(rawmat) <- 1:nrow(rawmat)
rawmat <- as.data.frame(rawmat)
rawmat[, 1] <- as.character(first[, 1])
rawmat[, 2] <- as.integer(first[, 2])
rawmat[, 3] <- as.integer(first[, 3])
for (i in seq_len(length(listcounts))) {
    rawmat[, names(listcounts)[i]] <- as.numeric(listcounts[[i]]$RPKM)
}
peakrpkms <- rawmat
first <- listcounts[[1]]
rawmat <- matrix(NA, nrow = nrow(first), ncol = length(listcounts) + 
                   3)
colnames(rawmat) <- c("Chr", "Start", "End", names(listcounts))
rownames(rawmat) <- 1:nrow(rawmat)
rawmat <- as.data.frame(rawmat)
rawmat[, 1] <- as.character(first[, 1])
rawmat[, 2] <- as.integer(first[, 2])
rawmat[, 3] <- as.integer(first[, 3])
for (i in seq_len(length(listcounts))) {
    rawmat[, names(listcounts)[i]] <- as.integer(listcounts[[i]]$Reads)
}
peakcounts <- rawmat
samples <- list()
conditions <- unique(sheet$Condition)
for (cond in conditions) {
    heresamples <- sheet$SampleID[sheet$Condition == cond]
    samples[[cond]] <- heresamples
}
vobj <- list(peakcounts = peakcounts, samples = samples, 
               peakrpkms = peakrpkms)

#Annotate

