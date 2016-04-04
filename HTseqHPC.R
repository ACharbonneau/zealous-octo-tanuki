require(ggplot2)
require(dplyr)
require(DESeq2)
require(gtools)

# setting a reasonable p-value threshold to be used throughout
p.threshold <- 0.05

#Import all of the count files from mapping AE reads to a single genome

countsDir <- file.path("/mnt/scratch/charbo24/AE_Assembly/Kitashiba2014")

outputfilename <- ("Kitashiba2014d_eseq2_expr_changes.csv")

ALLTHEFILES <- list.files(countsDir, pattern = "*.counts.txt")

meta <- read.csv("../metadata/metadata.csv")

File_Num <- length(ALLTHEFILES) 


#Merge Gene Counts


# Make first dataset into starting dataframe
ALLTHEGENES <- read.csv(ALLTHEFILES[ 1 ], sep = "\t", header = F, 
                        col.names = c("Genes", regmatches(ALLTHEFILES[ 1 ], regexec("[1-6]_2008[0-9]+_[0-9]_[A-Z]+[0-9]", ALLTHEFILES[ 1 ]))))

# Remove X from name of column 2
colnames(ALLTHEGENES) <- c("Genes", substring(colnames(ALLTHEGENES[2]),2))

row.names(ALLTHEGENES) <- ALLTHEGENES[,1]

# In a loop, read in each dataset, then merge it into the starting dataframe

for( X in c( 2:File_Num )){ #start at 2 because first dataset already in
  
  File_Search <- regexec("[1-6]_2008[0-9]+_[0-9]_[A-Z]+[0-9]", ALLTHEFILES[ X ])
  File_Name <- regmatches(ALLTHEFILES[ X ], File_Search)
  Temp_File <- read.csv(ALLTHEFILES[ X ], sep = "\t", header = F)
  colnames(Temp_File) <- c("Genes", File_Name)
  ALLTHEGENES <- inner_join( ALLTHEGENES, Temp_File )
  
}

row.names(ALLTHEGENES) <- ALLTHEGENES[,1]


# DESeq2 uses the `expressionset` data format, so the data needs to be reformatted to fit:


raph.exprs <- select(ALLTHEGENES, contains("_"))

raph.groups <- select(meta, FlowCell, Date, SampleInFC, ExID, Location, Line, SampleInLine)

raph.meta <- data.frame( description=c( "High",
                                        "Low") )

raph.est <- ExpressionSet( assayData=as.matrix(raph.exprs),
                           phenoData=new( "AnnotatedDataFrame", data=raph.groups))
#,
#varMetadata=raph.meta ))

# Create design matrix
design <- model.matrix(~ pData(raph.est)$Line )

# Create DESeq2 datasets
raph.DES <- DESeqDataSetFromMatrix(countData = exprs( raph.est ), colData = pData( raph.est ), design = ~ Line )
raph.DES <- DESeq( raph.DES )

# Plot dispersion estimates
plotDispEsts( raph.DES )

## DESeq2 - High vs Low
deseq2_results_hvl <- results( raph.DES, contrast=list( "LineHigh", "LineLow" ), cooksCutoff=FALSE, independentFiltering=FALSE )

deseq2_results_hvl$threshold <- as.logical( deseq2_results_hvl$padj < p.threshold )
deseq2_genes_hvl <- row.names( deseq2_results_hvl )[ which( deseq2_results_hvl$threshold )]

deseq2_results_hvl_df <- data.frame( deseq2_results_hvl )
deseq2_results_hvl_df$gene_name <- row.names( deseq2_results_hvl )
deseq2_results_hvl_df$FC <- logratio2foldchange(deseq2_results_hvl_df$log2FoldChange)

deseq2_results_hvl_df <- filter(deseq2_results_hvl_df, !is.na(log2FoldChange))

deseq2_results_hvl_df$ABlog2FoldChange <- abs(deseq2_results_hvl_df$log2FoldChange)

write.csv( deseq2_results_hvl_df, outputfilename, quote=FALSE, row.names=FALSE )
