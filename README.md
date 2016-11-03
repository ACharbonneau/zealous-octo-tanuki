# zealous-octo-tanuki
RNAseq Analysis of 2008 anther exertion line sequencing data

TLDR; 

1. Make a main directory
2. Clone repo onto HPC
2. Change hardcoded file paths in 1_PrepRawData.sh and 3_LaunchBuild.sh, if necessary
3. Run numbered scripts, in numerical order
	- .sh and .qsub scripts should be run from the main directory
	- .R and .Rmd scripts must be run from the script folder

##Files

0_BUSCO.sh

1_PrepRawData.sh

2_FastQC.qsub

3_LaunchBuild.sh

4_RunHTSeqAnalysis.R

5_MappingRates.R

bt2_build.qsub

gmap_build.qsub

bt2_mapping.qsub

gmap_mapping.qsub

view_samtools.qsub

htseq.qsub

BlastAnalysis.R

BUSCO.qsub

echo.qsub

fastaQual2fastq.pl

HTSeqAnalysis.Rmd

RenameAE_rawfiles.sh


##File Functions:

###1_PrepRawData.sh
Gets raw data, copies it to scratch and makes it useable, i.e. renames it and converts it
old sequence format to fastq.

Calls:
- RenameAE_rawfiles.sh

		Renames raw data file copies to have meaningful names instead of just being named
		"lane 1", etc

- fastaQual2fastq.pl

		I shamelessly stole this script from http://seqanswers.com/forums/showthread.php?t=2775
		to turn my .fna + .qual files into .fastq files. For reasons I'm not entirely sure of,
		it seems to work *except* that it adds a superfulous "!" to the end of each quality
		score line. I'm *reasonably* sure that kmcarr is Kevin Carr from RTSF, and I should
		just walk over and talk to him, but I haven't. For the moment, thie "!" is removed
		afterwards as a step in the PrepRawData.sh

- 2_FastQC.qsub

###2_FastQC.qsub
Runs FastQC on all files.

Calls: nothing

###3_LaunchBuild.sh
Script that has code for auto-submitting the qsubs for building the genome indices with the
right options. Paths to all files required for processing up until the HTseq count step are 
hard coded here and passed from qsub to qsub. This keeps walltime under 4 hours for most 
tasks, but keeps the user from having to track files. I'm quite proud of it.

The pipeline diverges so reads are mapped to 5 references, each with both BT2 and GSNAP/GMAP

This file begins auto-submission of several others, so it needs to be submitted
with variable lists for everything from building to counting reads with HT-seq. Example:

>qsub scripts/bt2_build.qsub -N \<name\> -v genome=\<genome\>,gff=\<gff\>,gffi="\<id_attribute\>",exon=\<exon_attribute\>,stranded="\<yes/no/reverse\>"

**name** is a string that will be used for naming the job (gets passed to name all folder & file output)

**genome** is full path to genome file in uncompressed fasta format

**gff** is full path to gff file, compressed or uncompressed

**gffi** is a quoted string of the GFF attribute to be used as feature ID

**exon** is a quoted string of the feature type (3rd column in GFF file) to be used

**stranded** is a quoted string of whether the data is from a strand-specific assay

NOTE: Spaces *matter*!

Calls:

- bt2_build.qsub
- gmap_build.qsub

###bt2_build.qsub and gmap_build.qsub
Build indicies for each reference, then spawns one mapping operation for every available
fastq file. 
Calls:

- bt2_mapping.qsub

OR

- gmap_mapping.qsub

###bt2_mapping.qsub and gmap_mapping.qsub

Maps reads for one individual to one reference using Bowtie2 or GMAP

Calls:

- echo.qsub

		A series of echo commands that write out the program versions and files used for
		a given individual for mapping through counting

- view_samtools.qsub

###view_samtools.qsub
Converts a sam file to bam and removes low quality mappings. In the case of transcriptomes,
samtools also makes a count file, otherwise the bam is passed to HTseq for counting.

Calls:

- htseq.qsub
- Reformat_TranscriptCounts.R

###htseq.qsub
Counts reads from a single individual to a give genome

Calls: nothing

###Reformat_TranscriptCounts.R
While reads mapped to a genome in this pipeline are counted by HTseq, reads mapped to the 
transcriptome are just counted by samtools. This works because the transcriptome is unassembled.
This script edits the samtools count file to be the same format as HTseq output, so they 
can all be put into the same DEseq2 pipeline.

Calls: nothing

###5_MappingRate.sh
Runs samtools to get statistics for mapping quality of each run

Calls: nothing

###6_RunHTSeqAnalysis.R
This is a driver script for the DEseq2 pipeline Rmd script. It will generate output files 
and pretty HTML summary documents for each mapping. This will alsooutput lists of 
differentially expressed genes, in csv format.

Calls:

- HTSeqAnalysis.Rmd

###HTSeqAnalysis.Rmd
Reads in all count files from mappings to a single reference, merges them into a single
expression data set, and uses DESeq to do differential expression analysis. Provides 
several exploratory data analysis as well as DE gene lists

###7_MappingRates.R
Script that uses output from HTSeqAnalysis.Rmd and 5_MappingRate.sh to plot mapping rate
differences among references and mappers


