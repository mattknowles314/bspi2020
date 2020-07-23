library(Gviz)
data("cpgIslands")
data("geneModels")
class(cpgIslands)

chr <- as.character(unique(seqnames(cpgIslands)))
gen <- genome(cpgIslands)

atrack <- AnnotationTrack(cpgIslands, name = "CpG")

plotTracks(atrack)

gtrack <- GenomeAxisTrack()

plotTracks(list(gtrack, atrack))

itrack <- IdeogramTrack(genome = gen, chromosome = chr)
plotTracks(list(itrack, gtrack, atrack))

gtrack <- GeneRegionTrack(geneModels, genome=gen, chromosome= chr, name = "Gene Model")
plotTracks(list(itrack, gtrack, atrack, gtrack))