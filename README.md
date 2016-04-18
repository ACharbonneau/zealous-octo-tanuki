# zealous-octo-tanuki
RNAseq Analysis of 2008 anther exertion line sequencing data 

##Files

1_PrepRawData.sh

2_FastQC.qsub

3_bt2_build.qsub

4_bt2_mapping.qsub

5_view_samtools.qsub

6_htseq.qsub

echo.qsub

RenameAE_rawfiles.sh

fastaQual2fastq.pl

HTSeqAnalysis.Rmd


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

###3_bt2_build.qsub
Builds a Bowtie2 index for a genome, then spawns one mapping operation for every available
fastq file. This qsub begins auto-submission of several others, so it needs to be submitted
with variable lists for everything from building to counting reads with HT-seq. Example:

>qsub scripts/3_bt2_build.qsub -N <name> -v genome=genome,gff=gf,gffi="<id attribute>",type="<feature type>"

name is a string that will be used for naming all folder & file output

genome is full path to genome file in uncompressed fasta format

gff is full path to gff file, compressed or uncompressed

gffi is a quoted string of the GFF attribute to be used as feature ID

type is a quoted string of the feature type (3rd column in GFF file) to be used

NOTE: Spaces *matter*!

Calls:

- 4_bt2_mapping.qsub

###4_bt2_mapping.qsub

Maps reads for one individual to one genome using Bowtie2

Calls: 

- echo.qsub

		A series of echo commands that write out the program versions and files used for 
		a given individual for mapping through counting

- 5_view_samtools.qsub

###5_view_samtools.qsub
Converts a sam file to bam and removes low quality mappings 

Calls:

- 6_htseq.qsub

###6_htseq.qsub
Counts reads from a single individual to a give genome

Calls: nothing

###HTSeqAnalysis.Rmd
Reads in all count files from mappings to a single genome, merges them into a single 
expression data set, and uses DESeq to do differential expression analysis.




