#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run *after* 1_RNAseq_HPCC.mk, on a computer that can install gSNAP

include scripts/config_2_Local.mk


Aligned_reads.txt : ChloroSat_SamFiles/bt2_chloro.sorted ChloroSat_SamFiles/gSNAP_${kmer}_chloro.sorted Sativus_SamFiles/bt2_sat.sorted Sativus_SamFiles/gSNAP_${kmer}_sat.sorted Moghe_SamFiles/bt2_moghe.sorted Moghe_SamFiles/gSNAP_${kmer}_moghe.sorted
	for i in *SamFiles/*.sorted.bam; do samtools view -c $${i}; done > Aligned_reads.txt

ChloroSat_SamFiles/bt2_chloro.sorted Sativus_SamFiles/bt2_sat.sorted Moghe_SamFiles/bt2_moghe.sorted : 
	echo "make -f scripts/1_RNAseq_HPCC.mk"


# Convert New Files

ChloroSat_SamFiles/gSNAP_${kmer}_chloro.sorted : ChloroSat_SamFiles/gSNAP_${kmer}_chloro.bam
	samtools sort $^ $@
	samtools index $@.bam

ChloroSat_SamFiles/gSNAP_${kmer}_chloro.bam : ChloroSat_SamFiles/gSNAP_${kmer}_chloro.sam
	samtools view -q 30 -b -T ${SatGenomeData_dir}/Rsativus_chloroplast.fa $^ > $@

Sativus_SamFiles/gSNAP_${kmer}_sat.sorted: Sativus_SamFiles/gSNAP_${kmer}_sat.bam
	samtools sort $^ $@
	samtools index $@.bam

Sativus_SamFiles/gSNAP_${kmer}_sat.bam : Sativus_SamFiles/gSNAP_${kmer}_sat.sam
	samtools view -q 30 -b -T ${SatGenomeData_dir}/RSA_r1.0 $^ > $@

Moghe_SamFiles/gSNAP_${kmer}_moghe.sorted : Moghe_SamFiles/gSNAP_${kmer}_moghe.bam
	samtools sort $^ $@
	samtools index $@.bam

Moghe_SamFiles/gSNAP_${kmer}_moghe.bam : Moghe_SamFiles/gSNAP_${kmer}_moghe.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@

# Mapping

ChloroSat_SamFiles/gSNAP_${kmer}_chloro.sam :: ${RNAData_dir}/*.fastq.edit 
	ls ChloroSat_SamFiles || mkdir ChloroSat_SamFiles
	ls ${GSNAP_dir}/Sat_Chloro_${kmer} || gmap_build -d ${GSNAP_dir}/Sat_Chloro_${kmer} -k ${kmer} ${SatGenomeData_dir}/Rsativus_chloroplast.fa	
	gsnap -d Sat_Chloro_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@
	
Sativus_SamFiles/gSNAP_${kmer}_sat.sam :: ${RNAData_dir}/*.fastq.edit 
	ls Sativus_SamFiles || mkdir Sativus_SamFiles
	ls ${GSNAP_dir}/Moghe_${kmer} || gmap_build -d ${GSNAP_dir}/Moghe_${kmer} -k ${kmer} ${SatGenomeData_dir}/RSA_r1.0	 
	gsnap -d Sat_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Moghe_SamFiles/gSNAP_${kmer}_moghe.sam :: ${RNAData_dir}/*.fastq.edit 
	ls Moghe_SamFiles || mkdir Moghe_SamFiles
	ls ${GSNAP_dir}/Moghe_${kmer} || gmap_build -d ${GSNAP_dir}/Moghe_${kmer} -k ${kmer} ${RapGenomeData_dir}/RrContigs.fa.fasta
	gsnap -d Moghe_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

