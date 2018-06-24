bioconductors <- function(x){
  x<- as.character(match.call()[[2]])
  if (!require(x, character.only = TRUE)){
    source("http://bioconductor.org/biocLite.R")
    biocLite(pkgs=x)
    require(x, character.only = TRUE)
  }
}

bioconductors(Rsamtools)
bioconductors(GenomicFeatures)
bioconductors(GenomicAlignments)

Inputfiles <- read.csv("../metadata/HTanalysisInputForR.csv")
Mapping <- "AT_2016_GS"


meta <- read.csv("../metadata/metadata.csv")

row.names(meta) <- meta[,1]

meta$LocationLine <- factor(paste(meta$Location, meta$Line, sep=""))


subgroup <- Inputfiles[ Inputfiles$Dataname == Mapping, ]


bamnames <- list.files(file.path(subgroup$countsDir), pattern = "*.sorted.bam$")
bamindex <- list.files(file.path(subgroup$countsDir), pattern = "*.sorted.bam.bai")


ALLTHEBAMS <- BamFileList(bamnames, index=bamindex)

gtffile <- file.path("/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_GFF3_genes.gff")
txdb <- makeTxDbFromGFF(gtffile, format = "gff")
txdb

exonbygene <- exonsBy(txdb, by="gene")

ALLTHEOVERLAPS <- summarizeOverlaps(features=exonbygene, reads=ALLTHEBAMS,
                        mode="Union",
                        singleEnd=TRUE,
                        ignore.strand=TRUE )

colData(ALLTHEOVERLAPS) <- DataFrame(sampleTable)

ALLTHEOVERLAPS$LocationLine <- relevel(ALLTHEOVERLAPS$LocationLine, ref="KBSLow")

ALLTHEOVERLAPS$Line <- relevel(ALLTHEOVERLAPS$Line, ref="Low")

ALLTHEOVERLAPS$Location <- relevel(ALLTHEOVERLAPS$Location, ref="KBS")


round( colSums(assay(se)) / 1e6, 1 )

