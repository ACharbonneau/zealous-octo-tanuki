#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run on the MSU HPC (or compute resource with similar
# hardware and software, and needs to run *before* RNAseq_local.mk


include scripts/config_1_HPC.mk


metadata/SeqProductionSumm.xls :
	cp ${metadata_dir}/SeqProductionSumm.xls metadata/SeqProductionSumm.xls
	
fastqc/%.fastqc.html : %.fastq.edit
	/opt/software/FastQC/0.11.3/fastqc $^ -o fastqc

%.fastq.edit : 
	bash ${Script_dir}/PrepRawData.sh
	
	
