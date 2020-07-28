setwd("~/Work/Internship 2020/gitrepo/Jessamy")

# Package installation

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DiffBind")

library(DiffBind)

# Load sample data

samples <- read.csv(file.path(system.file("extra",
                                          package = "DiffBind"),
                              "tamoxifen.csv"))
names(samples)  # [1] "SampleID"   "Tissue"     "Factor"     "Condition" 
                # [5] "Treatment"  "Replicate"  "bamReads"   "ControlID" 
                # [9] "bamControl" "Peaks"      "PeakCaller"
samples

tamoxifen <- dba(sampleSheet = "tamoxifen.csv",
                 dir = system.file("extra",
                                   package = "DiffBind"))
tamoxifen

plot(tamoxifen) # Visually same output as in vignette

# Count reads

tamoxifen <- dba.count(data("tamoxifen_counts"),
                       tamoxifen,
                       summits = 250)
tamoxifen
plot(tamoxifen)

# Contrast

tamoxifen <- dba.contrast(tamoxifen,
                          categories = DBA_CONDITION)

# Differential analysis

tamoxifen <- dba.analyze(tamoxifen)
tamoxifen

plot(tamoxifen,
     contrast = 1)

# Differentially bound sites identification

tamoxifen.DB <- dba.report(tamoxifen)
tamoxifen.DB

# Plotting

# PCA
data("tamoxifen_analysis")
dba.plotPCA(tamoxifen,
            DBA_TISSUE,
            label = DBA_CONDITION)
dba.plotPCA(tamoxifen,
            contrast = 1,
            label = DBA_TISSUE)

# MA
dba.plotMA(tamoxifen)

# Volcano
dba.plotVolcano(tamoxifen)

# Boxplots
sum(tamoxifen.DB$Fold<0) # 535
sum(tamoxifen.DB$Fold>0) # 94
pvals <- dba.plotBox(tamoxifen)
pvals

#heatmaps
corvals <- dba.plotHeatmap(tamoxifen)
corvals <- dba.plotHeatmap(tamoxifen,
                           contrast = 1,
                           correlations = FALSE)

# Using blocking factor

data("tamoxifen_counts")
tamoxifen <- dba.contrast(tamoxifen,
                          categories = DBA_CONDITION,
                          block = tamoxifen$masks$MCF7)
tamoxifen <- dba.analyze(tamoxifen)
tamoxifen

dba.plotMA(tamoxifen, method = DBA_DESEQ2_BLOCK)
tamoxifen <- dba.analyze(tamoxifen, method = DBA_ALL_METHODS)
dba.show(tamoxifen, bContrasts = T)[9:12] #   DB.edgeR DB.edgeR.block DB.DESeq2 DB.DESeq2.block
                                          # 1      331            599       629             738

tam.block <- dba.report(tamoxifen,
                        method = DBA_ALL_METHODS_BLOCK,
                        bDB=TRUE,
                        bAll=TRUE)
tam.block
dba.plotVenn(tam.block,
             1:4,
             label1 = "edgeR",
             label2 = "DESeq2",
             label3 = "edgeR Blocked",
             label4 = "DESeq2 Blocked")

# Overlaps

data("tamoxifen_peaks")
olap.rate <- dba.overlap(tamoxifen,
                         mode = DBA_OLAP_RATE)
olap.rate # 3795 2845 1773 1388 1074  817  653  484  384  202  129

plot(olap.rate,
     type = 'b',
     ylab = '# peaks',
     xlab = 'Overlap at least this many peaksets')

# Consensus peaksets

names(tamoxifen$masks)

dba.overlap(tamoxifen,
            tamoxifen$masks$MCF7 & tamoxifen$masks$Responsive,
            mode = DBA_OLAP_RATE) # 1780 1215  885

dba.plotVenn(tamoxifen,
             tamoxifen$masks$MCF7 & tamoxifen$masks$Responsive)

tamoxifen_consensus <- dba.peakset(tamoxifen,
                                   consensus = c(DBA_TISSUE,
                                               DBA_CONDITION),
                                   minOverlap = 0.66)
tamoxifen_consensus <- dba(tamoxifen_consensus,
                           mask = tamoxifen_consensus$masks$Consensus,
                           minOverlap = 1)
tamoxifen_consensus


consensus_peaks <- dba.peakset(tamoxifen_consensus,
                               bRetrieve = TRUE)

data(tamoxifen_peaks)
tamoxifen <- dba.peakset(tamoxifen,
                         consensus = DBA_TISSUE,
                         minOverlap = 0.66)
dba.plotVenn(tamoxifen,
             tamoxifen$masks$Consensus)

# Unique sites

data(tamoxifen_peaks)

dba.overlap(tamoxifen,
            tamoxifen$masks$Resistant,
            mode = DBA_OLAP_RATE) # 2029 1375  637  456
dba.overlap(tamoxifen,
            tamoxifen$masks$Responsive,
            mode = DBA_OLAP_RATE) # 3416 2503 1284  865  660  284  180

tamoxifen <- dba.peakset(tamoxifen,
                         consensus = DBA_CONDITION,
                         minOverlap = 0.33)
dba.plotVenn(tamoxifen,
             tamoxifen$masks$Consensus)

tamoxifen.OL <- dba.overlap(tamoxifen,
                            tamoxifen$masks$Consensus)
tamoxifen.OL$onlyA
tamoxifen.OL$onlyB

# Occupancy vs Affinity

tamoxifen <- dba.peakset(tamoxifen,
                         tamoxifen$masks$Consensus,
                         minOverlap = 1,
                         sampID = "OL Consensus")
tamoxifen <- dba.peakset(tamoxifen,
                         !tamoxifen$masks$Consensus,
                         minOverlap = 3,
                         sampID = "Consensus_3")
dba.plotVenn(tamoxifen,
             14:15)

data(tamoxifen_analysis)

tamoxifen.rep <- dba.report(tamoxifen,
                            bCalled = TRUE,
                            th = 1)

onlyResistant <- tamoxifen.rep$Called1 >= 2 & tamoxifen.rep$Called2 < 3
sum(onlyResistant) # 473

onlyResponsive <- tamoxifen.rep$Called2 >= 3 & tamoxifen.rep$Called1 < 2
sum(onlyResponsive) # 417

bothGroups <- tamoxifen.rep$Called1 >= 2 & tamoxifen.rep$Called2 >= 3
sum(bothGroups) # 864

tamoxifen.DB <- dba.report(tamoxifen,
                           bCalled = T)
onlyResistant.DB <- tamoxifen.DB$Called1 >= 2 & tamoxifen.DB$Called2 <3
sum(onlyResistant.DB) # 70
onlyResponsive.DB <- tamoxifen.DB$Called2 >= 3 & tamoxifen.DB$Called1 <2
sum(onlyResponsive.DB) # 205
bothGroups.DB <- tamoxifen.DB$Called1 >= 2 & tamoxifen.DB$Called2 >= 3
sum(bothGroups.DB) # 66
