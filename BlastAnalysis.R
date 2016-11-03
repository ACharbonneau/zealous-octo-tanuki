
rm(list = ls())
require(dplyr)
require(limma)
require(plotrix)
require(RColorBrewer)

gg_color_hue <- function(n) {
  hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

blastheaders <- c("qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore")

DEheaders <- c("basemean", "log2foldchange", "lfcMLE", "lfcSE", "stat", "pvalue", "padj", "threshold", "sseqid", "FC", "Ablog2FoldChange")

Kitashiba2014c <- read.csv("../JeongBlast/Kitashiba2014_HvL_vs_Jeong.csv", col.names = paste(blastheaders,"K2014", sep="", coll="") )
K14DE <- read.csv("../DEseqOutput/Kitashiba2014_deseq2_expr_changes_HvL.SIG.csv", header = F, col.names = paste(DEheaders, "K2014", sep="", coll=""))
K14DE$sseqidK2014 <- sub("gene:", "", K14DE$sseqidK2014)
K14DE <- select(K14DE, padjK2014, log2foldchangeK2014, sseqidK2014)
FullK14 <- full_join(Kitashiba2014c, K14DE, by= c("qseqidK2014" = "sseqidK2014"))


Mitsui2015c <- read.csv("../JeongBlast/Mitsui2015_HvL_vs_Jeong.csv", col.names = paste(blastheaders,"M2015", sep="", coll="") )
Mitsui2015c$qseqidM2015 <- sub(".t1", "", Mitsui2015c$qseqidM2015)
M15DE <- read.csv("../DEseqOutput/Mitsui2015_deseq2_expr_changes_HvL.SIG.csv", header = F, col.names = paste(DEheaders, "M2015", sep="", coll=""))
M15DE <- select(M15DE, padjM2015, log2foldchangeM2015, sseqidM2015)
FullM15 <- full_join(Mitsui2015c, M15DE, by= c("qseqidM2015" = "sseqidM2015"))


Moghe2014c <- read.csv("../JeongBlast/Moghe2014_HvL_vs_Jeong.csv", col.names = paste(blastheaders,"M2014", sep="", coll="") )
M14DE <- read.csv("../DEseqOutput/Moghe2014_deseq2_expr_changes_HvL.SIG.csv", header = F, col.names = paste(DEheaders, "M2014", sep="", coll=""))
M14DE$sseqidM2014 <- sub("-mRNA-1", "", M14DE$sseqidM2014)
M14DE <- select(M14DE, padjM2014, log2foldchangeM2014, sseqidM2014)
FullM14 <- full_join(Moghe2014c, M14DE, by= c("qseqidM2014" = "sseqidM2014"))

Jeong2016c <- read.csv("../JeongBlast/Jeong2016_deseq2_expr_changes_HvL.Proteinlist.txt", col.names = c("sseqid", "Jeong2016"), sep=",")
Jeong2016c$Jeong2016 <- "Hit"
J16DE <- read.csv("../DEseqOutput/Jeong2016_deseq2_expr_changes_HvL.SIG.csv", header = F, col.names = paste(DEheaders, "J2016", sep="", coll=""))
J16DE <- select(J16DE, padjJ2016, log2foldchangeJ2016, sseqidJ2016)
FullJ16 <- full_join(Jeong2016c, J16DE, by= c("sseqid" = "sseqidJ2016"))

AllAnn <- read.csv("../JeongBlast/AllJeongAnnotations.txt", col.names = c("sseqid", "annotation"), sep=",")


test <- left_join(AllAnn, FullM15, by= c("sseqid" = "sseqidM2015"))

test1 <- left_join(test, FullM14, by= c("sseqid" = "sseqidM2014"))
rm(test)
test2 <- left_join(test1, FullK14, by= c("sseqid" = "sseqidK2014"))
rm(test1)
test3 <- left_join(test2, FullJ16, by="sseqid")
rm(test2)
#write.csv(test3, "../figures/BlastDEAll.csv")
test3$allNA <- rowSums( is.na( test3[,3:44] ))

test4 <- test3[ test3$allNA < 42, ]

write.csv(test4, "../figures/BlastDEnoNA.csv")


Justgenes <- select(test4, sseqid, qseqidK2014, qseqidM2014, qseqidM2015, Jeong2016)

Moghe2014 <- !is.na(Justgenes$qseqidM2014)
Kitashiba2014 <- !is.na(Justgenes$qseqidK2014)
Mitsui2015 <- !is.na(Justgenes$qseqidM2015)
Jeong2016 <- !is.na(Justgenes$Jeong2016) 
c4 <- cbind(Jeong2016, Kitashiba2014, Mitsui2015, Moghe2014 )
vennall <- vennCounts(c4)

pdf("../figures/BlastVenn.pdf")
vennDiagram(vennall, circle.col = gg_color_hue(4), cex = .8, main= "DE genes by Genome") 
dev.off()



Moghe <- dim(filter(test4, !is.na(qseqidM2014) ))[1]
Kit <- dim(filter(test4, !is.na(qseqidK2014) ))[1]
Mit <- dim(filter(test4, !is.na(qseqidM2015) ))[1]
Jeong <- dim(filter(test4, !is.na(Jeong2016) ))[1]




All4 <- dim(filter(test4, !is.na(qseqidM2015) & !is.na(qseqidM2014) & !is.na(qseqidK2014) & !is.na(Jeong2016)))[1]

Moghe_Jeong <- dim(filter(test4, !is.na(Jeong2016) & !is.na(qseqidM2014) ))[1]

Moghe_Kit <- dim(filter(test4, !is.na(qseqidK2014) & !is.na(qseqidM2014) ))[1]

Moghe_Mit <- dim(filter(test4, !is.na(qseqidM2015) & !is.na(qseqidM2014) ))[1]

Mit_Kit <- dim(filter(test4, !is.na(qseqidK2014) & !is.na(qseqidM2015) ))[1]
Kit_Jeong <- dim(filter(test4, !is.na(Jeong2016) & !is.na(qseqidK2014) ))[1]
Mit_Jeong <- dim(filter(test4, !is.na(Jeong2016) & !is.na(qseqidM2015) ))[1]

row1 <- c( "Jeong2016", "Kitashiba2014", "Mitsui2015", "Moghe2014")
row2 <- c( Jeong, Kit_Jeong, Mit_Jeong, Moghe_Jeong)
row3 <- c( Kit_Jeong, Kit, Mit_Kit, Moghe_Kit)
row4 <- c( Mit_Jeong, Mit_Kit, Mit, Moghe_Mit )
row5 <- c(Moghe_Jeong, Moghe_Kit, Moghe_Mit, Moghe)
col1 <- c("Jeong2016", "Kitashiba2014", "Mitsui2015", "Moghe2014")

mappedTable <- as.data.frame(rbind(row2, row3, row4, row5))
colnames(mappedTable) <- row1
rownames(mappedTable) <- col1

pdf("../figures/BlastTable1_1.pdf")
par(mar = c(0.5, 8, 7, 0.5))
color2D.matplot(mappedTable, 
                show.values = TRUE,
                axes = FALSE,
                xlab = "",
                ylab = "",
                vcex = 1,
                vcol = "black",
                main= "DE genes by genome",
                extremes = c(brewer.pal(4, "Paired")[1], brewer.pal(4, "Paired")[2]))
axis(3, at = seq_len(ncol(mappedTable)) - 0.5,
     labels = names(mappedTable), tick = FALSE, cex.axis = 1)
axis(2, at = seq_len(nrow(mappedTable)) -0.5,
     labels = rev(rownames(mappedTable)), tick = FALSE, las = 1, cex.axis = 1)

dev.off()


MogheGenes <- filter(test4, !is.na(qseqidM2014) ) %>% 
  select(sseqid, qseqidM2014, padjM2014, log2foldchangeM2014, evalueM2014, annotation) %>% 
  arrange(padjM2014)

KitashibaGenes <- filter(test4, !is.na(qseqidK2014) ) %>% 
  select(sseqid, qseqidK2014, padjK2014, log2foldchangeK2014, evalueK2014, annotation) %>% 
  arrange(padjK2014)

MitsuiGenes <- filter(test4, !is.na(qseqidM2015) ) %>% 
  select(sseqid, qseqidM2015, padjM2015, log2foldchangeM2015, evalueM2015, annotation) %>% 
  arrange(padjM2015)

JeongGenes <- filter(test4, !is.na(Jeong2016) ) %>% 
  select(sseqid, padjJ2016, log2foldchangeJ2016, annotation) %>% 
  arrange(padjJ2016)

write.csv(MogheGenes, "../figures/MogheGenes.csv", row.names = F)
write.csv(KitashibaGenes, "../figures/KitashibaGenes.csv", row.names = F)
write.csv(MitsuiGenes, "../figures/MitsuiGenes.csv", row.names = F)
write.csv(JeongGenes, "../figures/JeongGenes.csv", row.names = F)

write.table((filter(test4, is.na(qseqidM2014) ) %>% select(annotation)), "../figures/MogheNotDE.txt", row.names = F, quote = F, col.names = F)
write.table((filter(test4, is.na(qseqidK2014) ) %>% select(annotation)), "../figures/KitashibaNotDE.txt", row.names = F, quote = F, col.names = F)
write.table((filter(test4, is.na(qseqidM2015) ) %>% select(annotation)), "../figures/MitsuiNotDE.txt", row.names = F, quote = F, col.names = F)
write.table((filter(test4, is.na(Jeong2016) ) %>% select(annotation)), "../figures/JeongNotDE.txt", row.names = F, quote = F, col.names = F)

