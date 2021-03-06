#!/bin/bash

#Sativus Genome:
#Jeong, Y.-M., Kim, N., Ahn, B. O., Oh, M., Chung, W.-H., Chung, H., et al.
#(2016). Elucidating the triplicated ancestral genome structure of radish based
#on chromosome-level comparison with the Brassica genomes. Theoretical and
#Applied Genetics, 1–16. http://doi.org/10.1007/s00122-016-2708-0


#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N Jeong2016_BT -v genome=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Rs_1.0.chromosomes.fix.fasta,gff=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Edited_Rs_1.0.Gene.LFY.gff,gffi="Derives_from",exon="protein",stranded="yes"

qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N Jeong2016_GS -v genome=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Rs_1.0.chromosomes.fix.fasta,gff=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Edited_Rs_1.0.Gene.LFY.gff,gffi="Derives_from",exon="protein",stranded="yes"


#Sativus Genome: Draft sequences of the radish (Raphanus sativus L.) genome
#Kitashiba H, Li F, Hirakawa H, Kawanabe T, Zou Z, Hasegawa Y, Tonosaki K,
#Zhang Z, Shirasawa S, Fukushima A, Yokoi S, Takahata Y, Kakizaki T, Ishida M,
#Okamoto S, Sakamoto K, Shirasawa K, Tabata S, Nishio T (2014)


#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N Kitashiba2014_BT -v genome=/mnt/research/radishGenomics/PublicData/RsativusGenome/Edit_RSA_r1.0.fasta,gff=/mnt/research/radishGenomics/PublicData/RsativusGenome/RSA_r1.0_genes.gff3.gz,gffi="Parent",exon="exon",stranded="no"

qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N Kitashiba2014_GS -v genome=/mnt/research/radishGenomics/PublicData/RsativusGenome/Edit_RSA_r1.0.fasta,gff=/mnt/research/radishGenomics/PublicData/RsativusGenome/RSA_r1.0_genes.gff3.gz,gffi="Parent",exon="exon",stranded="no"


#Sativus Genome: Mitsui, Y., Shimomura, M., Komatsu, K., Namiki, N.,
#Shibata-Hatta, M., Imai, M., et al. (2015). The radish genome and comprehensive
#gene expression profile of tuberous root formation and development.
#Nature Publishing Group, 1–14. http://doi.org/10.1038/srep10835

#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N Mitsui2015_BT -v genome=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsg_all_v1.fasta,gff=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsgv1.gff,gffi="Parent",exon="CDS",stranded="no"

qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N Mitsui2015_GS -v genome=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsg_all_v1.fasta,gff=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsgv1.gff,gffi="Parent",exon="CDS",stranded="no"



#Raphanistrum Genome: Moghe, G. D., Hufnagel, D. E., Tang, H., Xiao, Y.,
#Dworkin, I., Town, C. D., et al. (2014). Consequences of Whole-Genome
#Triplication as Revealed by Comparative Genomic Analyses of the Wild Radish
#Raphanus raphanistrum and Three Other Brassicaceae Species. The Plant Cell
#Online, 26(5), 1925–1937. http://doi.org/10.1105/tpc.114.124297

#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N Moghe2014_BT -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/RrContigs.fa.fasta,gff=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/Rr_gene_pseu.gff.mod,gffi="Parent",exon="exon",stranded="no"

qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N Moghe2014_GS -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/RrContigs.fa.fasta,gff=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/Rr_gene_pseu.gff.mod,gffi="Parent",exon="exon",stranded="no"



#Raphanistrum transcriptome RR3_NY
#ESTs

#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N RR3NYEST_BT -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/EST_7pops/RR3_NY/1000017.fa,gff=NA,gffi="NA",exon="NA",stranded="NA"

qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N RR3NYEST_GS -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/EST_7pops/RR3_NY/1000017.fa,gff=NA,gffi="NA",exon="NA",stranded="NA"

#Brassica oleracea UNIGENES, unique. ftp://ftp.ncbi.nih.gov/repository/UniGene/
#Tack thinks this is the best thing to map to

#awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < /mnt/research/radishGenomics/PublicData/brassica_oleracea/Bol.seq.uniq > /mnt/research/radishGenomics/PublicData/brassica_oleracea/Edit_Bol.seq.uniq

#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N BOUNI_BT -v genome=/mnt/research/radishGenomics/PublicData/brassica_oleracea/Edit_Bol.seq.uniq,gff=NA,gffi="NA",exon="NA",stranded="NA"

#qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N BOUNI_GS -v genome=/mnt/research/radishGenomics/PublicData/brassica_oleracea/Edit_Bol.seq.uniq,gff=NA,gffi="NA",exon="NA",stranded="NA"


#Arabidopsis thaliana genome

#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N AT2016_BT -v genome=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_chr_all.fas,gff=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_GFF3_genes.gff,gffi="Parent",exon="exon",stranded="no"

#qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N AT2016_GS -v genome=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_chr_all.fas,gff=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_GFF3_genes.gff,gffi="Parent",exon="exon",stranded="no"

# Nie, S., Li, C., Xu, L., Wang, Y., Huang, D., Muleke, E. M., et al. (2016).
# De novo transcriptome analysis in radish (Raphanus sativus L.) and identification of critical genes involved in bolting and flowering.
# BMC Genomics, 17(1), 1–16. http://doi.org/10.1186/s12864-016-2633-2

#qsub zealous-octo-tanuki/1.2_bt2_build.qsub -N NieLeaf2016_BT -v genome=/mnt/research/radishGenomics/PublicData/Nie_Leaf_2016,gff="NA",gffi="NA",exon="NA",stranded="NA"

#qsub zealous-octo-tanuki/1.2_gmap_build.qsub -N NieLeaf2016_GS -v genome=/mnt/research/radishGenomics/PublicData/Nie_Leaf_2016,gff="NA",gffi="NA",exon="NA",stranded="NA"



#cd BUSCO/ || exit

#qsub ../zealous-octo-tanuki/1.1_BUSCO.qsub -N Jeong2016 -v genome=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Rs_1.0.chromosomes.fix.fasta
#
#qsub ../zealous-octo-tanuki/1.1_BUSCO.qsub -N Kitashiba2014 -v genome=/mnt/research/radishGenomics/PublicData/RsativusGenome/Edit_RSA_r1.0.fasta
#
#qsub ../zealous-octo-tanuki/1.1_BUSCO.qsub -N Mitsui2015 -v genome=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsg_all_v1.fasta
#
#qsub ../zealous-octo-tanuki/1.1_BUSCO.qsub -N Moghe2014 -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/RrContigs.fa.fasta
#
#qsub ../zealous-octo-tanuki/1.1_BUSCO.qsub -N AT2016 -v genome=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_chr_all.fas
#
