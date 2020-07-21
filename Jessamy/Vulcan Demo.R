# Package installation

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("vulcan")
BiocManager::install("vulcandata")

library(vulcan)
library(vulcandata)

# Import and annotate BAM/BED files

vfile <- tempfile()
vulcandata::vulcansheet(vfile)

vobj <- vulcan.import(vfile) # potentially wasn't supposed to do this?
vobj <- vulcandata::vulcanexample()
unlink(vfile)

vobj <- vulcan.annotate(vobj, lborder=-10000, rborder=10000, method="sum")
                      
vobj<-vulcan.normalize(vobj)
names(vobj$samples) # "t90" "t45" "t0"

load(system.file("extdata", "network.rda", package="vulcandata", mustWork=TRUE))