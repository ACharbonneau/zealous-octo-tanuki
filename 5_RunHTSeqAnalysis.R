# This runs HTSeqAnalysis.Rmd on all sequencing runs listed in HTanalysisInputForR.csv
rm(list = ls())

require(knitr)
Inputfiles <- read.csv("../metadata/HTanalysisInputForR.csv")


for (Mapping in unique(Inputfiles$Dataname)){
  rmarkdown::render("HTSeqAnalysis.Rmd", output_file=paste( Mapping, "_DESeq2Analysis.html", sep=""),
                    output_dir=paste("../DEseqOutput/", Mapping, sep=""))
}        