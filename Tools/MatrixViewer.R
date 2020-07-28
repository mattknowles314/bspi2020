

setwd("                 ") # Insert your working directory folder here

################################### VERSION 1 ##########################################

# This version produces a 'Formal class ExpressionSet' data format

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

library(GEOquery)

SMatrix = getGEO(filename = "              ") # Insert pathway to your copy of GSE32222_series_matrix.txt here

################################### VERSION 2 ##########################################

# This version produces a classic dataframe style table

SMatrixV2 <- read.table("MatrixEdit.txt", sep = "\t") # MatrixEdit.txt is a changed copy of the original file available in 'tools'
SMatrixV2 <- t(SMatrixV2)

colnames(SMatrixV2) <- as.character(unlist(SMatrixV2[1,]))
SMatrixV2 = SMatrixV2[-1, ]

View(SMatrixV2)

# Optional code to export data to spreadsheet (in format "Path\\filename.csv")
write.csv(SMatrixV2,
          "                    \\              ",
          row.names = FALSE)
