setwd("C:/Users/jessa/Documents/Internship 2020")

################################### VERSION 1 ##########################################

# This version produces a 'Formal class ExpressionSet' SMatrixV2a format

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

library(GEOquery)

SMatrixV1 = getGEO(filename = "GSE32222_series_matrix.txt")

################################### VERSION 2 ##########################################

# This version produces a classic SMatrixV2aframe style table

SMatrixV2 <- read.table("MatrixEdit.txt", sep = "\t")
SMatrixV2 <- t(SMatrixV2)

colnames(SMatrixV2) <- as.character(unlist(SMatrixV2[1,]))
SMatrixV2 = SMatrixV2[-1, ]

View(SMatrixV2)

write.csv(SMatrixV2,
          "C:/Users/jessa/Documents/Internship 2020\\SMatrix.csv",
          row.names = FALSE)
