#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run on the MSU HPC or compute resource with similar
# hardware and software, and needs to run *before* 2_RNAseq_local.mk


include scripts/config_1_HPC.mk 

all : ChloroSat_SamFiles/bt2_chloro.sorted Sativus_SamFiles/bt2_sat.sorted Moghe_SamFiles/bt2_moghe.sorted
	echo "From local machine run: make -f scripts/2_RNAseq_local.mk"

# Convert New Files

ChloroSat_SamFiles/bt2_chloro.sorted : ChloroSat_SamFiles/bt2_chloro.bam
	samtools sort $^ $@
	samtools index $@.bam

ChloroSat_SamFiles/bt2_chloro.bam : ChloroSat_SamFiles/bt2_chloro.sam
	qsub ViewSamtools.qsub -v genome="${SatGenomeData_dir}/Rsativus_chloroplast.fa",samfile="$^",outputfile="$@"

Sativus_SamFiles/bt2_sat.sorted : Sativus_SamFiles/bt2_sat.bam
	samtools sort $^ $@
	samtools index $@.bam

Sativus_SamFiles/bt2_sat.bam : Sativus_SamFiles/bt2_sat.sam
	qsub ViewSamtools.qsub -v genome="${SatGenomeData_dir}/RSA_r1.0",samfile="$^",outputfile="$@"

Moghe_SamFiles/bt2_moghe.sorted : Moghe_SamFiles/bt2_moghe.bam
	samtools sort $^ $@
	samtools index $@.bam

Moghe_SamFiles/bt2_moghe.bam : Moghe_SamFiles/bt2_moghe.sam
	qsub ViewSamtools.qsub -v genome="${RapGenomeData_dir}/RrContigs.fa.fasta",samfile="$^",outputfile="$@"

2015Sat_SamFiles/bt2_2015sat.sorted : 2015Sat_SamFiles/bt2_2015sat.bam
	samtools sort $^ $@
	samtools index $@.bam

2015Sat_SamFiles/bt2_2015sat.bam : 2015Sat_SamFiles/bt2_2015sat.sam
	qsub ViewSamtools.qsub -v genome="${2015SatGenomeData_dir}/rsg_all_v1.fasta",samfile="$^",outputfile="$@"


# Mapping

Moghe_SamFiles/bt2_moghe.sam : ${RNAData_dir}/*.fastq.edit
	ls Moghe_SamFiles || mkdir Moghe_SamFiles
	ls Bowtie_Indices || mkdir Bowtie_Indices
	ls Bowtie_Indices/bt2_moghe*.bt2 || qsub bt2_build.qsub -N BowtieMogheIndex -v genome="${RapGenomeData_dir}/RrContigs.fa.fasta",index="Bowtie_Indices/bt2_moghe"
	qsub scripts/bt2_mapping.qsub -N "$@" -o Moghe_SamFiles/ -v genome="Bowtie_Indices/bt2_moghe",indiv="$^"

ChloroSat_SamFiles/bt2_chloro.sam : ${RNAData_dir}/*.fastq.edit
	ls ChloroSat_SamFiles || mkdir ChloroSat_SamFiles
	ls Bowtie_Indices || mkdir Bowtie_Indices
	ls Bowtie_Indices/bt2_chloro*.bt2 || qsub bt2_build.qsub -N BowtieChloroIndex -v genome="${SatGenomeData_dir}/Rsativus_chloroplast.fa",index="Bowtie_Indices/bt2_chloro"
	qsub scripts/bt2_mapping.qsub -N "$@" -o ChloroSat_SamFiles/ -v genome="Bowtie_Indices/bt2_chloro",indiv="$^"
	
Sativus_SamFiles/bt2_sat.sam : ${RNAData_dir}/*.fastq.edit
	ls sat_SamFiles || mkdir sat_SamFiles
	ls Bowtie_Indices || mkdir Bowtie_Indices
	ls Bowtie_Indices/bt2_sat*.bt2 || qsub bt2_build.qsub -N BowtieSatIndex -v genome="${SatGenomeData_dir}/RSA_r1.0",index="Bowtie_Indices/bt2_sat"
	qsub scripts/bt2_mapping.qsub -N "$@" -o Sativus_SamFiles/ -v genome="Bowtie_Indices/bt2_sat",indiv="$^"

2015Sat_SamFiles/bt2_2015sat.sam : ${RNAData_dir}/*.fastq.edit
	ls 2015Sat_SamFiles || mkdir 2015Sat_SamFiles
	ls Bowtie_Indices || mkdir Bowtie_Indices
	ls Bowtie_Indices/bt2_2015sat*.bt2 || qsub bt2_build.qsub -N 2015Sat_SamFiles -v genome="${2015SatGenomeData_dir}/rsg_all_v1.fasta",index="Bowtie_Indices/bt2_2015sat"
	qsub scripts/bt2_mapping.qsub -N "$@" -o 2015Sat_SamFiles/ -v genome="Bowtie_Indices/bt2_2015sat",indiv="$^"

metadata/SeqProductionSumm.xls :
	cp ${metadata_dir}/SeqProductionSumm.xls metadata/SeqProductionSumm.xls
	
fastqc/%.fastqc.html : %.fastq.edit
	/opt/software/FastQC/0.11.3/fastqc $^ -o fastqc

${RNAData_dir}/6_20081211_7_KL9.fastq.edit : 
	bash ${Script_dir}/PrepRawData.sh
	
	
