# Convert EST counts from Samtools to same format as HTseq count files and naming scheme
rm(list = ls())

# Install function for packages    
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(dplyr)


countsDir <- file.path(".")

ALLTHEFILES <- list.files(countsDir, pattern = "*.samtools.*")

for( X in 1:length(ALLTHEFILES)){
  FileName <- readLines(file(ALLTHEFILES[ X ]), n=1)
  TempFile <- read.table(ALLTHEFILES[ X ], sep = "\t", header = F, skip = 1)
  NewFile <- dplyr::select(TempFile, V1, V3 )
  write.table(NewFile, paste(FileName, ".counts.txt", sep=""), sep="\t", row.names=F, col.names=F, quote=F)
}

