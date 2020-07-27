

setwd("C:/Users/jessa/Documents/Internship 2020")

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

library(GEOquery)

SMatrix = getGEO(filename = "GSE32222_series_matrix.txt")
view(SMatrix)
