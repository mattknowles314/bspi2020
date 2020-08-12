setwd("/home/matthew/Documents/BSPIData/")

library(vulcan)

load_files <- function(){
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescont.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesDB.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesdba.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplespeaks.Rdata")
}

#BASED ON VULCAN.IMPORT BUT CHANGED TO SUIT MY COMPUTER
import <- function (sheetfile, intervals = 210, samples_dba) 
{
  sheet <- read.csv(sheetfile, as.is = TRUE)
  dbobj <- samples_dba
  message("Sheet loaded. You have ", nrow(sheet), " samples and ", 
          length(unique(sheet$Condition)), " conditions")
  dbcounts <- DiffBind::dba.count(dbobj, summits = intervals,  bParallel = FALSE)
  listcounts <- dbcounts$peaks
  names(listcounts) <- dbcounts$samples[2, 1]
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
  return(vobj)
}

#ANNOTATE
annotated_data <- vulcan.annotate(vobj, lborder=-10000, rborder=10000,method="sum")

#NORMALIZE
normalized_data <- vulcan.normalize(annotated_data)

#LOAD ARCANe NETWORK
load(system.file("extdata","network.rda",package="vulcandata",mustWork=TRUE))

#VULCAN ANALYSIS
vobj_analysis <- vulcan(normalized_data,network=network, minsize=5)

vulcan_pipieline <- function() {
  #I WILL PUT THE COMPLETED PIPELINE IN HERE WHEN IT IS
}