
# Install function for packages    
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

packages(dplyr)

Genelist <- read.csv("../DEseqOutput/Mitsui2015_DE_BM20.csv")

MitsuiAnn <- read.csv("../metadata/Mitsuiannotation/Annotation (tab).txt", sep = "\t")
MitsuiAnn$gene_name <- sub(".t[0-9]", "", MitsuiAnn$Sequence.Name)


AnnGenelist <- dplyr::left_join(Genelist, MitsuiAnn)

write.csv(AnnGenelist, "../DEseqOutput/Annotated_Mitsui2015_DE_BM20.csv", row.names = F)
