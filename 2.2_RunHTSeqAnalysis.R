# This runs HTSeqAnalysis.Rmd on all sequencing runs listed in HTanalysisInputForR.csv
rm(list = ls())

# Install function for packages
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(knitr)
packages(rmarkdown)


Inputfiles <- read.csv("../metadata/HTanalysisInputForR.csv")


for (Mapping in unique(Inputfiles$Dataname)){
  rmarkdown::render("2.3_DESeq_AE_analysis.Rmd", output_file=paste( Mapping, "_DESeq2Analysis.html", sep=""),
                    output_dir=paste("../DEseqOutput/", Mapping, sep=""))
}
