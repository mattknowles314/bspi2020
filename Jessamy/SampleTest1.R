setwd("~/Work/Internship 2020")

###################################################################### Packages

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("vulcan")
BiocManager::install("DiffBind")
BiocManager::install("Gviz")

library(vulcan)
library(DiffBind)
library(Gviz)

###################################################################### Load Data

# Sample GSM798383 used as test

# R appears capable of directly reading .gz files without unzipping
# Details of how to unzip https://stat.ethz.ch/pipermail/r-help/2015-February/425709.html

readLines("SampleData/GSM798383_SLX-1201.250.s_4_SLX-1202.250.s_1_peaks.txt.gz")
Sample <- read.table("SampleData/GSM798383_SLX-1201.250.s_4_SLX-1202.250.s_1_peaks.txt.gz",
                     header = TRUE)

###################################################################### Gviz

itrack <- IdeogramTrack(genome = gen, chromosome = chr)
plotTracks(list(itrack, gtrack, atrack))

library(GenomicRanges)
data(cpgIslands)
class(cpgIslands)
chr <- as.character(unique(seqnames(cpgIslands)))
gen <- genome(cpgIslands)
atrack <- AnnotationTrack(cpgIslands, name = "CpG")

###################################################################### DiffBind

