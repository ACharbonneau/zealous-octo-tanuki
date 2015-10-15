#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run on the MSU HPC or compute resource with similar
# hardware and software, and needs to run *before* 2_RNAseq_local.mk


include scripts/config_1_HPC.mk 


all : ChloroSat_SamFiles/bt2_chloro.sorted Sativus_SamFiles/bt2_sat.sorted Moghe_SamFiles/bt2_moghe.sorted
	exit && exit && cd ${localRNAData_dir}
	make -f scripts/2_RNAseq_local.mk
	

# Convert New Files

ChloroSat_SamFiles/bt2_chloro.sorted : ChloroSat_SamFiles/bt2_chloro.bam
	module load SAMTools/1.2
	samtools sort $^ $@
	samtools index $@.bam

ChloroSat_SamFiles/bt2_chloro.bam : ChloroSat_SamFiles/bt2_chloro.sam
	module load SAMTools/1.2
	samtools view -q 30 -b -T ${SatGenomeData_dir}/Rsativus_chloroplast.fa $^ > $@

Sativus_SamFiles/bt2_sat.sorted : Sativus_SamFiles/bt2_sat.bam
	module load SAMTools/1.2
	samtools sort $^ $@
	samtools index $@.bam

Sativus_SamFiles/bt2_sat.bam : Sativus_SamFiles/bt2_sat.sam
	module load SAMTools/1.2
	samtools view -q 30 -b -T ${SatGenomeData_dir}/RSA_r1.0 $^ > $@

Moghe_SamFiles/bt2_moghe.sorted : Moghe_SamFiles/bt2_moghe.bam
	module load SAMTools/1.2
	samtools sort $^ $@
	samtools index $@.bam

Moghe_SamFiles/bt2_moghe.bam : Moghe_SamFiles/bt2_moghe.sam
	module load SAMTools/1.2
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@

# Mapping

Moghe_SamFiles/bt2_moghe.sam : ${HPCRNAData_dir}/*.fastq.edit
	module load bowtie2/2.2.6
	ls Moghe_SamFiles || mkdir Moghe_SamFiles
	ls Bowtie_Indices/bt2_moghe*.bt2 || mkdir Bowtie_Indices && \
		bowtie2-build RapGenomeData_dir/RrContigs.fa.fasta Bowtie_Indices/bt2_moghe
	bowtie2 --local -D 15 -R 2 -N 0 -L 20 -i S,1,0.75 -x Bowtie_Indices/bt2_moghe -U $^ -S $@

ChloroSat_SamFiles/bt2_chloro.sam : ${HPCRNAData_dir}/*.fastq.edit
	module load bowtie2/2.2.6
	ls Chloro_SamFiles || mkdir Chloro_SamFiles
	ls Bowtie_Indices/bt2_chloro*.bt2 || mkdir Bowtie_Indices && \
		bowtie2-build SatGenomeData_dir/Rsativus_chloroplast.fa Bowtie_Indices/bt2_chloro
	bowtie2 --local -D 15 -R 2 -N 0 -L 20 -i S,1,0.75 -x Bowtie_Indices/bt2_chloro -U $^ -S $@

Sativus_SamFiles/bt2_sat.sam : ${HPCRNAData_dir}/*.fastq.edit
	module load bowtie2/2.2.6
	ls sat_SamFiles || mkdir sat_SamFiles
	ls Bowtie_Indices/bt2_sat*.bt2 || mkdir Bowtie_Indices && \
		bowtie2-build SatGenomeData_dir/RSA_r1.0 Bowtie_Indices/bt2_sat
	bowtie2 --local -D 15 -R 2 -N 0 -L 20 -i S,1,0.75 -x Bowtie_Indices/bt2_sat -U $^ -S $@


metadata/SeqProductionSumm.xls :
	cp ${metadata_dir}/SeqProductionSumm.xls metadata/SeqProductionSumm.xls
	
fastqc/%.fastqc.html : %.fastq.edit
	/opt/software/FastQC/0.11.3/fastqc $^ -o fastqc

%.fastq.edit : 
	bash ${Script_dir}/PrepRawData.sh
	
	
