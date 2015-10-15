#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run *after* 1_RNAseq_HPCC.mk, on a computer that can install gSNAP

include scripts/config_2_Local.mk


Aligned_reads.txt : ChloroSat_SamFiles/${kmer}.chloro.sorted Sativus_SamFiles/${kmer}.sat.sorted Moghe_SamFiles/${kmer}.moghe.sorted
	for i in *SamFiles/*.sorted.bam; do samtools view -c $${i}; done > Aligned_reads.txt

# Convert New Files

ChloroSat_SamFiles/${kmer}.chloro.sorted : ChloroSat_SamFiles/${kmer}.chloro.bam
	samtools sort $^ $@
	samtools index $@.bam

ChloroSat_SamFiles/${kmer}.chloro.bam : ChloroSat_SamFiles/${kmer}.chloro.sam
	samtools view -q 30 -b -T ${SatGenomeData_dir}/Rsativus_chloroplast.fa $^ > $@

Sativus_SamFiles/${kmer}.sat.sorted: Sativus_SamFiles/${kmer}.sat.bam
	samtools sort $^ $@
	samtools index $@.bam

Sativus_SamFiles/${kmer}.sat.bam : Sativus_SamFiles/${kmer}.sat.sam
	samtools view -q 30 -b -T ${SatGenomeData_dir}/RSA_r1.0 $^ > $@

Moghe_SamFiles/${kmer}.moghe.sorted : Moghe_SamFiles/${kmer}.moghe.bam
	samtools sort $^ $@
	samtools index $@.bam

Moghe_SamFiles/${kmer}.moghe.bam : Moghe_SamFiles/${kmer}.moghe.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@

# Mapping

ChloroSat_SamFiles/${kmer}.chloro.sam :: ${RNAData_dir}/*.fastq.edit 
	ls ChloroSat_SamFiles || mkdir ChloroSat_SamFiles
	ls ${GSNAP_dir}/Sat_Chloro_${kmer} || gmap_build -d ${GSNAP_dir}/Sat_Chloro_${kmer} -k ${kmer} ${SatGenomeData_dir}/Rsativus_chloroplast.fa	
	gsnap -d Sat_Chloro_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@
	
Sativus_SamFiles/${kmer}.sat.sam :: ${RNAData_dir}/*.fastq.edit 
	ls Sativus_SamFiles || mkdir Sativus_SamFiles
	ls ${GSNAP_dir}/Moghe_${kmer} || gmap_build -d ${GSNAP_dir}/Moghe_${kmer} -k ${kmer} ${SatGenomeData_dir}/RSA_r1.0	 
	gsnap -d Sat_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Moghe_SamFiles/${kmer}.moghe.sam :: ${RNAData_dir}/*.fastq.edit 
	ls Moghe_SamFiles || mkdir Moghe_SamFiles
	ls ${GSNAP_dir}/Moghe_${kmer} || gmap_build -d ${GSNAP_dir}/Moghe_${kmer} -k ${kmer} ${RapGenomeData_dir}/RrContigs.fa.fasta
	gsnap -d Moghe_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

