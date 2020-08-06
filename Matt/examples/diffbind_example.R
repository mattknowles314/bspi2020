#http://bioconductor.org/packages/release/bioc/vignettes/DiffBind/inst/doc/DiffBind.pdf

library(DiffBind)

testsamples <- read.csv(file.path(system.file("extra", package="DiffBind"), "tamoxifen.csv"))
names(samples)

tamoxifen <- dba(sampleSheet = "tamoxifen.csv", dir=system.file("extra", package="DiffBind"))
plot(tamoxifen) #Priduces corrolation heatmap using occupancy data. (peak caller score)

data("tamoxifen_counts")
tamoxifen <- dba.count(tamoxifen, summits = 250)
#New column added FrIp - Fraction of Reads in Peaks
tamoxifen

plot(tamoxifen)

tamoxifen <- dba.contrast(tamoxifen, categories = DBA_CONDITION)
tamoxifen

#Now we prefordm the differential analysis

tamoxifen <- dba.analyze(tamoxifen)
tamoxifen
plot(tamoxifen, contrast =1 )

#Finally, we need to retrieve the differentially bound sites
tamoxifen.DB <- dba.report(tamoxifen)
df.DB
