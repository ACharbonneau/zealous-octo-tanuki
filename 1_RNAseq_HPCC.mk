#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run on the MSU HPC (or compute resource with similar
# hardware and software, and needs to run *before* RNAseq_local.mk


include scripts/config_1_HPC.mk

Nothing : fastqc/*.fastqc

#edit this to not need script. it takes for fuck ever
#also make it go find and copy over the metadata so I can have an r script do something
#	with the mapping output
#and write the r script

	
fastqc/%.fastqc : %.fastq.edit
	/opt/software/FastQC/0.11.3/fastqc $^ -o fastqc

%.fastq.edit : 
	bash ${Script_dir}/PrepRawData.sh
	
	
