# This runs DifferentialGenesPseudo.Rmd on all sequencing runs listed in DifferentialGenesPseudoInputForR.csv
rm(list = ls())

require(dplyr)
require(ggplot2)
#Setting a reasonable p-value threshold to be used throughout
p.threshold <- 0.05
basemean.threshold <- 20

Inputfiles <- read.csv("../metadata/DifferentialGenesPseudoInputForR.csv")

#  Mapping="Mitsui2015_BT"
manageablelist <- list()
X=1
  
for (Mapping in unique(Inputfiles$DataFile)){
  datasubset <- Inputfiles[ Inputfiles$DataFile == Mapping, ]
  DEfile <- read.csv(paste("../DEseqOutput/", datasubset$InputFile, sep = ""))
  
  manageablelist[[X]] <- dplyr::filter(DEfile, padj_KBS <= p.threshold & padj_Reed <= p.threshold) %>% 
    dplyr::filter( ( log2FoldChange_KBS > 0 & log2FoldChange_Reed > 0 )  | 
                     ( log2FoldChange_KBS < 0 & log2FoldChange_Reed < 0 ) ) %>%
    dplyr::filter(baseMean_Reed > basemean.threshold) %>%
    dplyr::filter(( abs(log2FoldChange_KBS) > .5 & abs(log2FoldChange_Reed) ) > .5) %>%
    dplyr::select(gene_name, baseMean=baseMean_Reed, log2FoldChange_Reed, 
                  padj_Reed, baseMean_KBS, log2FoldChange_KBS, padj_KBS)

  write.csv(manageablelist[[X]], paste("../DEseqOutput/", Mapping[1],"/",Mapping[1], "_DE_BM", basemean.threshold, ".csv",  sep = ""), row.names = F  )
  manageablelist[[X]]$Dataset <- Mapping
  X = X + 1
  }

manageablejoin <- list()

X=1
for ( NUM in seq(1, 10, by=2)){
  manageablejoin[[X]] <- inner_join(manageablelist[[NUM]], manageablelist[[NUM + 1]], by="gene_name")
  colnames(manageablejoin[[X]]) <- c("gene_name","baseMean_BT","log2FoldChange_Reed_BT","padj_Reed_BT","baseMean_KBS_BT","log2FoldChange_KBS_BT","padj_KBS_BT","Dataset_BT","baseMean_GS","log2FoldChange_Reed_GS","padj_Reed_GS","baseMean_KBS_GS","log2FoldChange_KBS_GS","padj_KBS_GS","Dataset_GS")
  write.csv(manageablejoin[[X]], paste("../DEseqOutput/",sub("_GS", "", manageablejoin[[X]]$Dataset_GS[1]), "_DE_BM", basemean.threshold, ".csv", sep = ""), row.names = F )
  X = X + 1
}

