# Convert EST counts from Samtools to same format as HTseq count files and naming scheme
rm(list = ls())

require(dplyr)

countsDir <- file.path("./")

#whereami <- getwd()
#whereami <- basename(whereami)

ALLTHEFILES <- list.files(countsDir, pattern = "*.samtools.*")

for( X in 1:length(ALLTHEFILES)){
  FileName <- readLines(file(paste(countsDir, "/", ALLTHEFILES[ X ], sep="")), n=1)
  TempFile <- read.table(paste(countsDir, "/", ALLTHEFILES[ X ], sep=""), sep = "\t", header = F, skip = 1)
  NewFile <- dplyr::select(TempFile, V1, V3 )
  write.table(NewFile, paste(FileName, ".counts.txt", sep=""), sep="\t", row.names=F, col.names=F, quote=F)
}

for( X in 1:length(ALLTHEGSFILES)){
  FileName <- readLines(file(paste(countsDirGS, "/", ALLTHEGSFILES[ X ], sep="")), n=1)
  TempFile <- read.table(paste(countsDirGS, "/", ALLTHEGSFILES[ X ], sep=""), sep = "\t", header = F, skip = 1)
  NewFile <- dplyr::select(TempFile, V1, V3)
  write.table(NewFile, paste("../RawData/RR3_NY_EST_GS/", FileName, ".counts.txt", sep=""), sep="\t", row.names=F, col.names=F, quote=F)
}
