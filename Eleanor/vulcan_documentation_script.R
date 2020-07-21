#commit test 2
library(vulcan)
library(vulcandata)
# Generate an annotation file from the dummy ChIP-Seq dataset
vfile<-tempfile()
vulcandata::vulcansheet(vfile)
 # Import BAM and BED information into a list object
 # vobj<-vulcan.import(vfile)
vobj<-vulcandata::vulcanexample()
unlink(vfile)
# Annotate peaks to gene names
 vobj<-vulcan.annotate(vobj,lborder=-10000,rborder=10000,method="sum")
# Normalize data for VULCAN analysis
 vobj<-vulcan.normalize(vobj)
# Detect which conditions are present in our imported object
  names(vobj$samples)
  load(system.file("extdata","network.rda",package="vulcandata",mustWork=TRUE))
  #run vulcan 
  vobj_analysis<-vulcan(vobj,network=network,contrast=c("t90","t0"),minsize=5)
  plot(vobj_analysis$msviper,mrs=7)
  #gene set enrichment analysis
  reflist<-setNames(-sort(rnorm(1000)),paste0("gene",1:1000))
  set<-paste0("gene",sample(1:200,50))
  obj<-gsea(reflist,set,method="pareto")
  obj$p.value
plot_gsea(obj)  
#rank enrichment analysis 
signatures<-setNames(-sort(rnorm(1000)),paste0("gene",1:1000))
set1<-paste0("gene",sample(1:200,50))
set2<-paste0("gene",sample(1:1000,50))
groups<-list(set1=set1,set2=set2)
obj<-rea(signatures=signatures,groups=groups)
obj
#convenience functions
par(mfrow=c(1,2))
# Thousands 
set.seed(1)
a<-runif(1000,0,1e4)
plot(a,yaxt="n")
kmg<-kmgformat(pretty(a))
axis(2,at=pretty(a),labels=kmg)
# Millions to Billions
set.seed(1)
a<-runif(1000,0,1e9)
plot(a,yaxt="n",pch=20,col=val2col(a))
kmg<-kmgformat(pretty(a))
axis(2,at=pretty(a),labels=kmg)
