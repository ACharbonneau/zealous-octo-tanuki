rm(list = ls())

# Install function for packages
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

packages(ggplot2)
packages(dplyr)
packages(stringr)
#packages(GGally)

folders <- list.dirs(file.path("../DEseqOutput"), full.names = F, recursive = F)

mappedfiles <- list.files(paste("../DEseqOutput/", folders, sep = ""), pattern ="*_counts.csv")

ALLTHEFILES <- read.csv(paste("../DEseqOutput/", folders[1], "/", mappedfiles[1], sep = ""))
ALLTHEFILES$Run <- folders[1]

for( X in 2:length(mappedfiles)){
  tempfile <- read.csv(paste("../DEseqOutput/", folders[X], "/", mappedfiles[X], sep = ""))
  tempfile$Run <- folders[X]
  ALLTHEFILES <- rbind(ALLTHEFILES, tempfile)
}

ALLTHEFILES$Run <- as.factor(ALLTHEFILES$Run)

metadata <- as.data.frame(cbind(levels(ALLTHEFILES$Run)))

metadata[,2:3] <-  t(as.data.frame(strsplit(as.character(metadata[,1]), split="_")))                          

colnames(metadata) <- c("Run", "Genome", "Mapper")

ALLTHEFILES <- inner_join(ALLTHEFILES, metadata)

ALLTHEFILES <- mutate(ALLTHEFILES, PerReadsMapped=MappedReads/TotalReads)

p <- ggplot(ALLTHEFILES, aes(TotalReads, MappedReads)) + 
      geom_point(aes(col=PerReadsMapped, shape=Genome), size=2 ) +
      scale_colour_distiller(palette = "RdBu", direction=1)

ggsave("../figures/MappedbyTotalReads.png", width = 7, height = 6)

p <- ggplot(ALLTHEFILES, aes(Run, X)) +
  geom_point(aes(size=MappedReads, col=-PerReadsMapped), shape=15 ) +
  xlab("") + ylab("") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave("../figures/MappedbyPercentReads.png", width = 8, height = 9)



#
#p <- ggpairs(AllMapStat, columns= c(4,5,7,9,11,12,15),
#        aes(col=Run, alpha=.1), axisLabels="show",
#        upper=list(continuous='blank'), legends = T)
#
#colidx <- c(4,5,7,9,11,12,15)
#for (i in 1:length(colidx)) {
#
#  # Address only the diagonal elements
#  # Get plot out of plot-matrix
#  inner <- getPlot(p, i, i);
#
#  # Add ggplot2 settings (here we remove gridlines)
#  inner <- inner + theme(panel.grid = element_blank()) +
#    theme(axis.text.x = element_blank())
#
#  # Put it back into the plot-matrix
#  p <- putPlot(p, inner, i, i)
#
#  for (j in 1:length(colidx)){
#    if((i==1 & j==1)){
#
#      # Move the upper-left legend to the far right of the plot
#      inner <- getPlot(p, i, j)
#      inner <- inner + theme(legend.position=c(length(colidx)-0.5,-1))
#      p <- putPlot(p, inner, i, j)
#    }
#    else{
#
#      # Delete the other legends
#      inner <- getPlot(p, i, j)
#      inner <- inner + theme(legend.position="none")
#      p <- putPlot(p, inner, i, j)
#    }
#  }
#}
#
#p <- p +  theme(axis.text.x = element_text(angle = 90, size = rel(0.7), hjust = 0),
#          panel.grid.major = element_line(colour = "grey95"),
#          panel.border = element_rect(colour = 'black'),
#          panel.margin = unit(0.5, "in"))
#
#pdf("../figures/MappingRates0_1.pdf", width = 8, height = 8)
#print(p, left = 1, bottom = .7)
#dev.off()
#
