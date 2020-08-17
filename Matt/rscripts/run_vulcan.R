setwd("/home/matthew/Documents/BSPIData/")

library(vulcan,silent=TRUE)
library(DiffBind,silent=TRUE)

load_files <- function(){
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescont.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesDB.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplesdba.Rdata")
  load(file = "/home/matthew/Documents/BSPIData/rdata/samplespeaks.Rdata")
}

#IMPORT - This replaces vulcan.import, dpne this way just to save time.

sheet <- read.csv("labelled_data.csv", as.is = TRUE)
dbobj <- samples_dba
message("Sheet loaded. You have ", nrow(sheet), " samples and ", 
          length(unique(sheet$Condition)), " conditions")
dbcounts <- samples_count
listcounts <- dbcounts$peaks
names(listcounts)<-dbcounts$samples[,1]
i = 0
while(i<=18){
  print(samplenums[["SampleID"]][i])
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

#Annotate - Replaces vulcan.annotate() just to tailor the function to this project

annotation <- toGRanges(TxDb.Hsapiens.UCSC.hg38.knownGene, feature = "gene") #vulcan.annotate() defaults to hg19, but hg38 used fot this project

gr <- GRanges(vobj$peakcounts) #Issue 2 starts here, see GitHub for more details.
anno <- annotatePeakInBatch(gr, AnnotationData = annotation, output = "overlapping",  FeatureLocForDistance = "TSS", bindingRegion = c(-10000, 10000))
dfanno <- anno
names(dfanno) <- seq_len(length(dfanno))
dfanno <- as.data.frame(dfanno)
allsamples <- unique(unlist(vobj$samples))
genes <- unique(dfanno$feature)
peakspergene <- table(dfanno$feature)
rawcounts <- matrix(NA, nrow = length(genes), ncol = length(allsamples))
colnames(rawcounts) <- allsamples
rownames(rawcounts) <- genes
genesone <- names(peakspergene)[peakspergene == 1]
for (gene in genesone) {
  rawcounts[gene, allsamples] <- as.numeric(dfanno[dfanno$feature == gene, allsamples])
}
genesmore <- names(peakspergene)[peakspergene > 1]
  rawcounts <- dist_calc(method, dfanno, rawcounts, genesmore, allsamples)
  gr <- GRanges(vobj$peakrpkms)
  anno <- annotatePeakInBatch(gr, AnnotationData = annotation, output = "overlapping", FeatureLocForDistance = "TSS", bindingRegion = c(-10000, 10000))
  dfanno <- anno
  names(dfanno) <- seq_len(length(dfanno))
  dfanno <- as.data.frame(dfanno)
  allsamples <- unique(unlist(vobj$samples))
  genes <- unique(dfanno$feature)
  peakspergene <- table(dfanno$feature)
  rpkms <- matrix(NA, nrow = length(genes), ncol = length(allsamples))
  colnames(rpkms) <- allsamples
  rownames(rpkms) <- genes
  genesone <- names(peakspergene)[peakspergene == 1]
  for (gene in genesone) {
    rpkms[gene, allsamples] <- as.numeric(dfanno[dfanno$feature == gene, allsamples])
  }
  genesmore <- names(peakspergene)[peakspergene > 1]
  rpkms <- dist_calc(method, dfanno, rpkms, genesmore, allsamples)
  rawcounts <- matrix(as.numeric(rawcounts), nrow = nrow(rawcounts), dimnames = dimnames(rawcounts))
  rpkms <- matrix(as.numeric(rpkms), nrow = nrow(rpkms), dimnames = dimnames(rpkms))
  vobj$rawcounts <- rawcounts
  vobj$rpkms <- rpkms
  return(vobj)
