setwd("~/Work/Internship 2020/gitrepo/Jessamy")

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

vobj <- vulcan.annotate(vobj,
                        lborder = -10000,
                        rborder = 10000,
                        method = "sum")
                      
vobj<-vulcan.normalize(vobj)
names(vobj$samples) # "t90" "t45" "t0"

# Load network

load(system.file("extdata",
                 "network.rda",
                 package = "vulcandata",
                 mustWork = TRUE))

# Run VULCAN

vobj_analysis <- vulcan(vobj,
                      network = network,
                      contrast = c("t90", "t0"),
                      minsize = 5)
plot(vobj_analysis$msviper, mrs = 7) # Visually same output as in vignette

# Other Tools

# Gene set enrichment analysis
reflist <- setNames(-sort(rnorm(1000)),
                  paste0("gene", 1:1000))
set <- paste0("gene", sample(1:200, 50))
objGSEA <- gsea(reflist,
            set,
            method="pareto")
objGSEA$p.value # 3.958149e-07
plot_gsea(objGSEA) # Visually same output as in vignette

# Rank enrichment analysis
signatures <- setNames(-sort(rnorm(1000)),
                       paste0("gene", 1:1000))
set1 <- paste0("gene", sample(1:200, 50))
set2 <- paste0("gene", sample(1:1000, 50))
groups <- list(set1 = set1,
               set2 = set2)
objREA <- rea(signatures = signatures,
              groups = groups)
objREA  #        sample1
        # set1  9.824419
        # set2 -1.688488

# Convenience functions
par(mfrow = c(1, 2))
set.seed(1)
a <- runif(1000, 0, 1e4)
plot(a,
     yaxt = "n")
kmg <- kmgformat(pretty(a))
axis(2,
     at = pretty(a),
     labels = kmg)
set.seed(1)
a <- runif(1000, 0, 1e9)
plot(a,
     yaxt = "n",
     pch = 20,
     col = val2col(a))
kmg <- kmgformat(pretty(a))
axis(2,
     at = pretty(a),
     labels = kmg) # Visually same output as in vignette