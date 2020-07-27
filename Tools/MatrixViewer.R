

setwd("                 ") # Insert your working directory folder here

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

library(GEOquery)

SMatrix = getGEO(filename = "              ") # Insert pathway to your copy of GSE32222_series_matrix.txt here
view(SMatrix)
