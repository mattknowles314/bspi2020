#In this file I am running the VULCAN example code just to get to grips with the package
#https://bioconductor.org/packages/release/bioc/vignettes/vulcan/inst/doc/vulcan.pdf

library("vulcan")
library("vulcandata")

#Here we generate an annotation from from a dummy ChIP-Seq dataset
vfile <- tempfile()
vulcandata::vulcansheet(vfile)

vobj <- vulcandata::vulcanexample()
unlink(vfile)

#Now we annotate the peaks to respective gene names
vobj <- vulcan.annotate(vobj,lborder=-10000,rborder=10000, method = "sum")

#We now bormalise data for VULCAN analysis
vobj <- vulcan.normalize(vobj)
#names(vobj$samples) #This tells us which conditions are present in the imported object

#Here wae use a regulon object from viper named "network"
load(system.file("extdata","network.rda",package = "vulcandata",mustWork = TRUE))

vobj_analysis <- vulcan(vobj,network=network, contrast=c("t90","t45"),minsize=5)
plot(vobj_analysis$msviper,mrs=7)

#Now we look to perform GSEA to fit a Pareto tail distribution
#This example generates an artificial signiture of 1000 genes with nomrally-distributed positive expression. 
reflist<-setNames(-sort(rnorm(1000)),paste0("gene",1:1000))
set<-paste0("gene",sample(1:200,50)) #Gene set composed of 50 genes randomly picked from a tail 
obj<-gsea(reflist,set,method = "pareto")
plot_gsea(obj)