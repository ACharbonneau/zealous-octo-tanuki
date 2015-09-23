#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run on the MSU HPC (or compute resource with similar
# hardware and software, and needs to run *before* RNAseq_local.mk

include scripts/config_2_Local.mk


Noreason : Sativus${kmer}SamFiles/6_20081211_7_KL9.sativus.sorted Sat_Chloro${kmer}SamFiles/6_20081211_7_KL9.chloro.sorted Moghe${kmer}SamFiles/6_20081211_7_KL9.edit.sorted


# Convert New Files

Sativus${kmer}SamFiles/%.sativus.sorted : Sativus${kmer}SamFiles/%.sativus.bam
	samtools sort $^ $@
	samtools index $@

Sativus${kmer}SamFiles/%.sativus.bam : Sativus${kmer}SamFiles/%.sativus.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@


Sat_Chloro${kmer}SamFiles/%.chloro.sorted : Sat_Chloro${kmer}SamFiles/%.chloro.bam
	samtools sort $^ $@
	samtools index $@

Sat_Chloro${kmer}SamFiles/%.chloro.bam : Sat_Chloro${kmer}SamFiles/%.chloro.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@


Moghe${kmer}SamFiles/%.edit.sorted : Moghe${kmer}SamFiles/%.edit.bam
	samtools sort $^ $@
	samtools index $@

Moghe${kmer}SamFiles/%.edit.bam : Moghe${kmer}SamFiles/%.edit.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@

# Mapping

Sativus${kmer}SamFiles/%.sativus.sam : ${RNAData_dir}/%.fastq.edit ${GSNAP_dir}/Sat_${kmer}
	mkdir Sativus${kmer}SamFiles
	gsnap -d Sat_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Sat_Chloro${kmer}SamFiles/%.chloro.sam : ${RNAData_dir}/%.fastq.edit ${GSNAP_dir}/Sat_chloro${kmer}
	mkdir Sat_Chloro${kmer}SamFiles
	gsnap -d Sat_chloro${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Moghe${kmer}SamFiles/%.edit.sam : ${RNAData_dir}/%.fastq.edit ${GSNAP_dir}/Moghe_${kmer}
	mkdir Moghe${kmer}SamFiles
	gsnap -d Moghe_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@


#Get Files


${GSNAP_dir}/Moghe_${kmer} : ${RapGenomeData_dir}/RrContigs.fa.fasta
	gmap_build -d $@ -k ${kmer} $^	
	
${GSNAP_dir}/Sat_chloro${kmer} : ${SatGenomeData_dir}/Rsativus_chloroplast.fa	
	gmap_build -d $@ -k ${kmer} $^
	
${GSNAP_dir}/Sat_${kmer} : ${SatGenomeData_dir}/RSA_r1.0	
	gmap_build -d $@ -k ${kmer} $^
