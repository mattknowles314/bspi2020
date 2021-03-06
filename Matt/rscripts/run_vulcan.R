setwd("/home/matthew/Documents/BSPIData/")

library(vulcan)
library(DiffBind)
library(imputeTS)
#BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(aracne.networks)
library(viper)
library(biomaRt)
library(org.Mm.eg.db)
library(org.Hs.eg.db)

load(file = "/home/matthew/Documents/BSPIData/brca-tf-regulon.rda")
load(file = "/home/matthew/Documents/BSPIData/metabric-regulon-tfs.rda")
load(file = "/home/matthew/Documents/BSPIData/rdata/samplesanalyze.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/samplescont.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/samplesDB.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/samplesdba.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/samplespeaks.Rdata")

regbrca <- regul

nameGene <- function(x){
  tab<-AnnotationDbi::select(org.Hs.eg.db,keys = x, columns = c("SYMBOL"), keytype = "ENTREZID")
  tab<-tab[!duplicated(tab[,"ENTREZID"]),]
  out<-setNames(tab[,"SYMBOL"],tab[,"ENTREZID"])
  out <- out[x]
  return(out)
}

names(regbrca)<-nameGene(names(regul))


sheet <- read.csv("labelled_data.csv", as.is = TRUE)
dbobj <- samples_dba
message("Sheet loaded. You have ", nrow(sheet), " samples and ", 
          length(unique(sheet$Condition)), " conditions")
dbcounts <- samples_count
listcounts <- dbcounts$peaks
names(listcounts)<-dbcounts$samples[,1]
first <- listcounts[[1]]
rawmat <- matrix(NA, nrow = nrow(first), ncol = length(listcounts) + 3)
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
rawmat <- matrix(NA, nrow = nrow(first), ncol = length(listcounts) + 3)
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
vobj <- list(peakcounts = peakcounts, samples = samples, peakrpkms = peakrpkms)

#Part 2: Modified version of vulcan.annotate()

annotation <- toGRanges(TxDb.Hsapiens.UCSC.hg38.knownGene, feature = "gene") #vulcan.annotate() defaults to hg19, but hg38 used fot this project
gr <- GRanges(vobj$peakcounts) 
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
#rawcounts <- dist_calc(method, dfanno, rawcounts, genesmore, allsamples)
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
#rpkms <- dist_calc(method, dfanno, rpkms, genesmore, allsamples)
rawcounts <- matrix(as.numeric(rawcounts), nrow = nrow(rawcounts), dimnames = dimnames(rawcounts))
rpkms <- matrix(as.numeric(rpkms), nrow = nrow(rpkms), dimnames = dimnames(rpkms))
vobj$rawcounts <- rawcounts
vobj$rpkms <- rpkms

#Part 3: modified version of vulcan.normalize():

samples <- vobj$samples
rawcounts <- vobj$rawcounts
allsamples <- unique(unlist(samples))
allgenes <- rownames(rawcounts)
conditions <- c()
for (i in seq_len(length(samples))) {
  conditions <- c(conditions, rep(names(samples)[i], length(samples[[i]])))
}
conditions <- factor(conditions)
vobj$rawcounts <- na_replace(vobj$rawcounts, 1) #Gets rid of NA objects, nifty.
cds <- DESeq::newCountDataSet(vobj$rawcounts, conditions)
cds <- DESeq::estimateSizeFactors(cds)
cds <- DESeq::estimateDispersions(cds, fitType = "local")
vsd <- DESeq::varianceStabilizingTransformation(cds)
normalized <- Biobase::exprs(vsd)
rownames(normalized) <- rownames(rawcounts)
vobj$normalized <- normalized

#The only function I haven't modified!
  
vobj_analysis_rvnr<-vulcan(vobj, regul, minsize=15, contrast = c("Responder", "Non-Responder"), annotation = names(regbrca)<-nameGene(names(regul))
)
vobj_analysis_rvnr[["msviper"]][["signature"]] <- na_replace(vobj_analysis_rvnr[["msviper"]][["signature"]],1)

vobj_analysis_rvm<-vulcan(vobj, regul, minsize=15, contrast = c("Responder", "Metastasis"), annotation = names(regbrca)<-nameGene(names(regul))
)
vobj_analysis_rvm[["msviper"]][["signature"]] <- na_replace(vobj_analysis_rvm[["msviper"]][["signature"]],1)

vobj_analysis_nrvm<-vulcan(vobj, regul, minsize=15, contrast = c("Non-Responder", "Metastasis"), annotation = names(regbrca)<-nameGene(names(regul))
)
vobj_analysis_nrvm[["msviper"]][["signature"]] <- na_replace(vobj_analysis_nrvm[["msviper"]][["signature"]],1)
#Gene Set Enrichment Analysis

reflist<-setNames(-sort(rnorm(1000)),paste0("gene",1:1000))
set<-paste0("gene",sample(1:200,50))
gseaobj<-gsea(reflist,set,method = "pareto")
  
save(vobj_analysis_rvnr, file="/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvnr.Rdata")
save(vobj_analysis_rvm, file="/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvm.Rdata")
save(vobj_analysis_nrvm, file="/home/matthew/Documents/BSPIData/rdata/vobjanalysisnrvm.Rdata")

png(file="~/Documents/BSPIData/plots/rvnr.png")
plot(vobj_analysis_rvnr$msviper, mrs=8)
dev.off()
png(file="~/Documents/BSPIData/plots/rvm.png")
plot(vobj_analysis_rvm$msviper, mrs=8)
dev.off()
png(file="~/Documents/BSPIData/plots/nrvm.png")
plot(vobj_analysis_nrvm$msviper, mrs=8)
dev.off()
png(file="~/Documents/BSPIData/plots/vulcgsea.png")
plot_gsea(gseaobj)
dev.off()

#Checking with another network
regbric <- regulon
names(regbric)<-nameGene(names(regulon))

vobj_analysis_rvnr_bric<-vulcan(vobj, regulon, minsize=10, contrast = c("Responder", "Non-Responder"), annotation = nameGene(names(regulon)))
vobj_analysis_rvnr_bric[["msviper"]][["signature"]] <- na_replace(vobj_analysis_rvnr_bric[["msviper"]][["signature"]],1)
png(file="~/Documents/BSPIData/plots/rvnrMETABRIC.png")
plot(vobj_analysis_rvnr_bric$msviper, mrs=8)
dev.off()

vobj_analysis_rvm_bric<-vulcan(vobj, regulon, minsize=10, contrast = c("Responder", "Metastasis"), annotation = nameGene(names(regulon)))
vobj_analysis_rvm_bric[["msviper"]][["signature"]] <- na_replace(vobj_analysis_rvm_bric[["msviper"]][["signature"]],1)
png(file="~/Documents/BSPIData/plots/rvmMETABRIC.png")
plot(vobj_analysis_rvm_bric$msviper, mrs=8)
dev.off()

vobj_analysis_nrvm_bric<-vulcan(vobj, regulon, minsize=10, contrast = c("Non-Responder", "Metastasis"), annotation = nameGene(names(regulon)))
vobj_analysis_nrvm_bric[["msviper"]][["signature"]] <- na_replace(vobj_analysis_nrvm_bric[["msviper"]][["signature"]],1)
png(file="~/Documents/BSPIData/plots/nrvmMETABRIC.png")
plot(vobj_analysis_nrvm_bric$msviper, mrs=8)
dev.off()

save(vobj_analysis_rvnr_bric, file="/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvnrb.Rdata")
save(vobj_analysis_rvm_bric, file="/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvmb.Rdata")
save(vobj_analysis_nrvm_bric, file="/home/matthew/Documents/BSPIData/rdata/vobjanalysisnrvmb.Rdata")
