require(ggplot2)
require(dplyr)
require(GGally)

MapStat <- read.csv("../AEmapping/AllMapping.csv", header = T)
MapStat_1 <- read.csv("../AEmapping/Redo/AllMapping.csv", header = T)
MapStat_1 <- filter(MapStat_1, Genome != "BO_UNI_0", Genome != "BO_UNI_1")
MapStat_1$Genome <- substr(as.character(MapStat_1$Genome), 
                           1, nchar(as.character(MapStat_1$Genome))-2 )


Kitashiba2014 <- read.csv("../DEseqOutput/Kitashiba2014_counts.csv", col.names = c("File", "HTSeq"))
Moghe2014 <- read.csv("../DEseqOutput/Moghe2014_counts.csv", col.names = c("File", "HTSeq"))
Jeong2016 <- read.csv("../DEseqOutput/Jeong2016_counts.csv", col.names = c("File", "HTSeq"))
Mitsui2015 <- read.csv("../DEseqOutput/Mitsui2015_counts.csv", col.names = c("File", "HTSeq"))
Kitashiba2014_1 <- read.csv("../DEseqOutput/Kitashiba2014_counts_1.csv", col.names = c("File", "HTSeq"))
Moghe2014_1 <- read.csv("../DEseqOutput/Moghe2014_counts_1.csv", col.names = c("File", "HTSeq"))
Jeong2016_1 <- read.csv("../DEseqOutput/Jeong2016_counts_1.csv", col.names = c("File", "HTSeq"))
Mitsui2015_1 <- read.csv("../DEseqOutput/Mitsui2015_counts_1.csv", col.names = c("File", "HTSeq"))

Kitashiba2014$Genome <- rep("Kitashiba2014", 35)
Moghe2014$Genome <- rep("Moghe2014", 35)
Jeong2016$Genome <- rep("Jeong2016", 35)
Mitsui2015$Genome <- rep("Mitsui2015", 35)
Kitashiba2014_1$Genome <- rep("Kitashiba2014", 35)
Moghe2014_1$Genome <- rep("Moghe2014", 35)
Jeong2016_1$Genome <- rep("Jeong2016", 35)
Mitsui2015_1$Genome <- rep("Mitsui2015", 35)

Kitashiba2014$Small <- rep("K14_0", 35)
Moghe2014$Small <- rep("M14_0", 35)
Jeong2016$Small <- rep("J16_0", 35)
Mitsui2015$Small <- rep("M15_0", 35)
Kitashiba2014_1$Small <- rep("K14_1", 35)
Moghe2014_1$Small <- rep("M14_1", 35)
Jeong2016_1$Small <- rep("J16_1", 35)
Mitsui2015_1$Small <- rep("M15_1", 35)

temp <- rbind(Kitashiba2014, Moghe2014, Jeong2016, Mitsui2015)
              
temp$Genome <- as.factor(temp$Genome)

temp_1 <- rbind(Kitashiba2014_1, Moghe2014_1, Jeong2016_1, Mitsui2015_1)

temp_1$Genome <- as.factor(temp_1$Genome)

AllMapStat_0 <- inner_join(MapStat, temp)
AllMapStat_1 <- inner_join(MapStat_1, temp_1)

AllMapStat_0$D <- rep("D0", length(AllMapStat_0$Genome))
AllMapStat_1$D <- rep("D1", length(AllMapStat_1$Genome))


AllMapStat <- rbind(AllMapStat_0, AllMapStat_1)

AllMapStat <- mutate(AllMapStat, PerReadsUsed = (HTSeq/TotalReads)*100, 
                     Run= as.factor(paste(Genome,"_", D, coll="", sep="")))
AllMapStat$D <- as.factor(AllMapStat$D)
AllMapStat$Small <- as.factor(AllMapStat$Small)


names(AllMapStat)

ggplot(AllMapStat, aes(AlignRate, PerReadsUsed)) + 
  geom_point(aes(col=Run)) + 
  geom_smooth(aes(col=Run))

ggplot(AllMapStat, aes( TotalReads, AlignRate)) + 
  geom_point(aes(col=Run)) #+ 
  #geom_smooth(aes(col=Run))

ggplot(AllMapStat, aes(OneAlign, MultiAlign)) + 
  geom_point(aes(col=Run)) #+ 
 # geom_smooth(aes(col=Run))


#pairplot <- ggpairs(AllMapStat, columns= c(4,5,7,9,11,12,14), aes(col=Genome, alpha=.1), axisLabels="show") +
#   theme(axis.text.x = element_text(angle = 90, size = rel(0.7), hjust = 0), 
#         panel.grid.major = element_line(colour = "grey95"),
#         panel.margin = unit(0.5, "in"))
#pdf("../figures/MappingRates.pdf", width = 9)
#print(pairplot, left = .5, bottom = .5)
#dev.off()
#
#runpairplot <- ggpairs(AllMapStat, columns= c(4,5,7,9,11,12,15), 
#                       aes(col=Small, alpha=.1), axisLabels="show",
#                       upper=list(continuous='blank')) +
#  theme(axis.text.x = element_text(angle = 90, size = rel(0.7), hjust = 0), 
#        panel.grid.major = element_line(colour = "grey95"),
#        panel.margin = unit(0.5, "in"))
#pdf("../figures/MappingRates0_1.pdf", width = 10, height = 10)
#print(runpairplot, left = .7, bottom = .7)
#dev.off()


p <- ggpairs(AllMapStat, columns= c(4,5,7,9,11,12,15), 
        aes(col=Run, alpha=.1), axisLabels="show",
        upper=list(continuous='blank'), legends = T) 

colidx <- c(4,5,7,9,11,12,15)
for (i in 1:length(colidx)) {
  
  # Address only the diagonal elements
  # Get plot out of plot-matrix
  inner <- getPlot(p, i, i);
  
  # Add ggplot2 settings (here we remove gridlines)
  inner <- inner + theme(panel.grid = element_blank()) +
    theme(axis.text.x = element_blank())
  
  # Put it back into the plot-matrix
  p <- putPlot(p, inner, i, i)
  
  for (j in 1:length(colidx)){
    if((i==1 & j==1)){
      
      # Move the upper-left legend to the far right of the plot
      inner <- getPlot(p, i, j)
      inner <- inner + theme(legend.position=c(length(colidx)-0.5,-1)) 
      p <- putPlot(p, inner, i, j)
    }
    else{
      
      # Delete the other legends
      inner <- getPlot(p, i, j)
      inner <- inner + theme(legend.position="none")
      p <- putPlot(p, inner, i, j)
    }
  }
}

p <- p +  theme(axis.text.x = element_text(angle = 90, size = rel(0.7), hjust = 0), 
          panel.grid.major = element_line(colour = "grey95"),
          panel.border = element_rect(colour = 'black'),
          panel.margin = unit(0.5, "in"))

pdf("../figures/MappingRates0_1.pdf", width = 8, height = 8)
print(p, left = 1, bottom = .7)
dev.off()
