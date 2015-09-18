# zealous-octo-tanuki
RNAseq Analysis of 2008 anther exertion line sequencing data 

##Files
**MAKE** files 1 and 2, and their respective config files, will redo all of the analysis given the prereqs listed in Prereqs
- 1_RNAseq_HPCC.mk
  - config_1_HPC.mk		
- 2_RNAseq_local.mk
  - config_2_Local.mk

Renames raw data file copies to have meaningful names instead of just being named "lane 1", etc
- RenameAE_rawfiles.sh	

I shamelessly stole this script from http://seqanswers.com/forums/showthread.php?t=2775 to turn my .fna + .qual files into .fastq files. For reasons I'm not entirely sure of, it seems to work *except* that it adds a superfulous "!" to the end of each quality score line. I'm *reasonably* sure that kmcarr is Kevin Carr from RTSF, and I should *probably* just walk over and talk to him, but I haven't. For the moment, thie "!" is removed afterwards as a step in my make file
- fastaQual2fastq.pl
