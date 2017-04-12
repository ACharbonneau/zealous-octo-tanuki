# zealous-octo-tanuki
RNAseq Analysis of 2008 anther exertion line sequencing data

This paper was built on the MSU High Performance Computing Cluster. Building it elsewhere will require installing several programs, and may require some editing of submission scripts. At a minimum, the machine running it will need:

git 2.10.1
FastQC 0.11.3
bowtie2 2.2.6
GMAP version 2016-05-01 (installed via linuxbrew)
SAMTools 1.2
HTSeq 0.6.1
R 3.2.0 (packages will auto-install)
pandoc 1.17.3

TLDR; 

1. Make a main directory
2. Clone repo onto HPC
2. Change hardcoded file paths in 1_PrepRawData.sh and 3_LaunchBuild.sh, if necessary
3. Run script 1_PrepRawData.qsub, from the main directory. 

> qsub zealous-octo-tanuki/1_PrepRawData.qsub

When that has completely finished:

4. Run script 2_MappingRate.qsub, from the main directory

> qsub zealous-octo-tanuki/2_MappingRate.qsub

## Files

1_PrepRawData.qsub

1.1_fastaQual2fastq.pl

1.1_FastQC.qsub

1.1_LaunchBuild.sh

1.1_RenameAE_rawfiles.sh

1.2_bt2_build.qsub

1.2_BUSCO.qsub

1.2_gmap_build.qsub

1.3_bt2_mapping.qsub

1.3_gmap_mapping.qsub

1.4_echo.qsub

1.4_view_samtools.qsub

1.5_htseq.qsub

2_MappingRate.qsub

2.1_Reformat_TranscriptCounts.R

2.2_RunHTSeqAnalysis.R

2.3_HTSeqAnalysis.Rmd

2.4_MappingRates.R

2.5_DifferentialGenesPseudoR.R

BlastAnalysis.R

MitsuiAnnotate.R

## File Functions:

### 1_PrepRawData.sh
Gets raw data, copies it to scratch and makes it useable, i.e. renames it and converts it
old sequence format to fastq.

Calls:
- 1.1_RenameAE_rawfiles.sh

		Renames raw data file copies to have meaningful names instead of just being named
		"lane 1", etc

- 1.1_fastaQual2fastq.pl

		I shamelessly stole this script from http://seqanswers.com/forums/showthread.php?t=2775
		to turn my .fna + .qual files into .fastq files. For reasons I'm not entirely sure of,
		it seems to work *except* that it adds a superfulous "!" to the end of each quality
		score line. I'm *reasonably* sure that kmcarr is Kevin Carr from RTSF, and I should
		just walk over and talk to him, but I haven't. For the moment, thie "!" is removed
		afterwards as a step in the PrepRawData.sh

- 1.1_FastQC.qsub
		Runs FastQC on all files.

- 1.1_BUSCO.qsub
		Runs BUSCO on all genomes

- 1.1_LaunchBuild.sh
		Script that has code for auto-submitting the qsubs for building the genome indices with the
		right options. Paths to all files required for processing up until the HTseq count step are 
		hard coded here and passed from qsub to qsub. This keeps walltime under 4 hours for most 
		tasks, but keeps the user from having to track files. I'm quite proud of it.

		The pipeline diverges so reads are mapped to 5 references, each with both BT2 and GSNAP/GMAP

		This file begins auto-submission of several others, so it needs to be submitted
		with variable lists for everything from building to counting reads with HT-seq. Example:

		>qsub scripts/1.2_bt2_build.qsub -N \<name\> -v genome=\<genome\>,gff=\<gff\>,gffi="\<id_attribute\>",exon=\<exon_attribute\>,stranded="\<yes/no/reverse\>"

		**name** is a string that will be used for naming the job (gets passed to name all folder & file output)

		**genome** is full path to genome file in uncompressed fasta format

		**gff** is full path to gff file, compressed or uncompressed

		**gffi** is a quoted string of the GFF attribute to be used as feature ID

		**exon** is a quoted string of the feature type (3rd column in GFF file) to be used

		**stranded** is a quoted string of whether the data is from a strand-specific assay

		NOTE: Spaces *matter*!

		Calls:

			- 1.2_bt2_build.qsub
			- 1.2_gmap_build.qsub

#### 1.2
- 1.2_bt2_build.qsub and 1.2_gmap_build.qsub
		Build indicies for each reference, then spawns one mapping operation for every available 
		fastq file. 
		
		Calls:

		- 1.3_bt2_mapping.qsub

	OR

		- 1.3_gmap_mapping.qsub

#### 1.3
- 1.3_bt2_mapping.qsub and 1.3_gmap_mapping.qsub

		Maps reads for one individual to one reference using Bowtie2 or GMAP

		Calls:

		- 1.4_echo.qsub

		A series of echo commands that write out the program versions and files used for
		a given individual for mapping through counting

		- 1.4_view_samtools.qsub

#### 1.4
- 1.4_view_samtools.qsub
		Converts a sam file to bam and removes low quality mappings. In the case of 
		transcriptomes, samtools also makes a count file, otherwise the bam is passed 
		to HTseq for counting.

- 1.4_echo.qsub

		A series of echo commands that write out the program versions and files used for
		a given individual for mapping through counting

		Calls:

		- 1.5_htseq.qsub

#### 1.5
- 1.5_htseq.qsub
		Counts reads from a single individual to a give genome

		Calls: nothing


### 2_MappingRate.qsub
Runs samtools to get statistics for mapping quality of each run

		Calls: 

		- 2.1_Reformat_TranscriptCounts.R


#### 2.1
- 2.1_Reformat_TranscriptCounts.R

		While reads mapped to a genome in this pipeline are counted by HTseq, reads 
		mapped to the transcriptome are just counted by samtools. This works because the 
		transcriptome is unassembled. This script edits the samtools count file to be the 
		same format as HTseq output, so they can all be put into the same DEseq2 pipeline.

		Calls: nothing

#### 2.2
- 2.2_RunHTSeqAnalysis.R

		This is a driver script for the DEseq2 pipeline Rmd script. It will generate output 
		files and pretty HTML summary documents for each mapping. This will alsooutput lists 
		of differentially expressed genes, in csv format.

		Calls:

		- 2.3_HTSeqAnalysis.Rmd

#### 2.3
- 2.3_HTSeqAnalysis.Rmd
		
		Reads in all count files from mappings to a single reference, merges them into a single
		expression data set, and uses DESeq to do differential expression analysis. Provides 
		several exploratory data analysis as well as DE gene lists

#### 2.4
- 2.4_MappingRates.R

		Script that uses output from 2.3_HTSeqAnalysis.Rmd and 5_MappingRate.sh to plot
		mapping rate differences among references and mappers
		
#### 2.5
- 2.5_DifferentialGenesPseudoR.R

		Script that compares results from gene lists across replicates to get high confidence
		genes
		
#### 2.6
- 2.6_MitsuiAnnotate.R
		
		Script that combines Mitsui annotations with Mitsui DE list

