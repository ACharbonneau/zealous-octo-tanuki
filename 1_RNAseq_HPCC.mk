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

%.fastq.edit : OriginalFiles/%.fna
	perl /mnt/research/radishGenomics/AssembledSequencingFiles/AE_RNA_Assembly/scripts/fastaQual2fastq.pl $^
	do cat $@ | sed s/\!$// > $@.edit; echo $@
	rm -r `ls -d 20081*/`
	rm *_ID*
	rm *.tar.gz
	mkdir OriginalFiles
	mv *.fna OriginalFiles/
	mv *.qual OriginalFiles/
	rm *.fastq


OriginalFiles/*.fna : 
	cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq/cel*/*.tar.gz .
	tar -zxvf 20081121.tar.gz  
	tar -zxvf 20081125.tar.gz  
	tar -zxvf 20081203.tar.gz  
	tar -zxvf 20081205_cel4.tar.gz  
	tar -zxvf 20081208.tar.gz  
	tar -zxvf 20081211.tar.gz
	#Rename to format: Cel_Date_Lane_PlantID.filetype
	bash /mnt/research/radishGenomics/AssembledSequencingFiles/AE_RNA_Assembly/scripts/RenameAE_rawfiles.sh

	
	
