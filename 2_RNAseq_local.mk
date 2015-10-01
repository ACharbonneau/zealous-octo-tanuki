#Produce a paper about RNAseq for anther exertion lines

# This make file needs to run on the MSU HPC (or compute resource with similar
# hardware and software, and needs to run *before* RNAseq_local.mk

include scripts/config_2_Local.mk


Noreason : Sativus${kmer}SamFiles/6_20081211_7_KL9.sativus.sorted Sat_Chloro_${kmer}SamFiles/6_20081211_7_KL9.chloro.sorted Moghe${kmer}SamFiles/6_20081211_7_KL9.edit.sorted


# Convert New Files

Sativus${kmer}SamFiles/%.sativus.sorted : Sativus${kmer}SamFiles/%.sativus.bam
	samtools sort $^ $@
	samtools index $@

Sativus${kmer}SamFiles/%.sativus.bam : Sativus${kmer}SamFiles/%.sativus.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@


Sat_Chloro_${kmer}SamFiles/%.chloro.sorted : Sat_Chloro_${kmer}SamFiles/%.chloro.bam
	samtools sort $^ $@
	samtools index $@

Sat_Chloro_${kmer}SamFiles/%.chloro.bam : Sat_Chloro_${kmer}SamFiles/%.chloro.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@


Moghe${kmer}SamFiles/%.edit.sorted : Moghe${kmer}SamFiles/%.edit.bam
	samtools sort $^ $@
	samtools index $@

Moghe${kmer}SamFiles/%.edit.bam : Moghe${kmer}SamFiles/%.edit.sam
	samtools view -q 30 -b -T ${RapGenomeData_dir}/RrContigs.fa.fasta $^ > $@

# Mapping

Sativus${kmer}SamFiles/%.sativus.sam : ${RNAData_dir}/%.fastq.edit
	gsnap -d Sat_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Sat_Chloro_${kmer}SamFiles/%.chloro.sam : ${RNAData_dir}/%.fastq.edit 
	gsnap -d Sat_Chloro_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Moghe${kmer}SamFiles/%.edit.sam : ${RNAData_dir}/%.fastq.edit 
	gsnap -d Moghe_${kmer} --force-single-end $^ -k ${kmer} -A sam -N 1 -O -n 1 -Q --nofails -o $@

Sativus${kmer}SamFiles/%.sativus.sam : ${GSNAP_dir}/Sat_${kmer}
Sat_Chloro_${kmer}SamFiles/%.chloro.sam : ${GSNAP_dir}/Sat_Chloro_${kmer}
Moghe${kmer}SamFiles/%.edit.sam : ${GSNAP_dir}/Moghe_${kmer}

Sativus${kmer}SamFiles :
	mkdir Sativus${kmer}SamFiles
	
Sat_Chloro_${kmer}SamFiles :
	mkdir Sat_Chloro_${kmer}SamFiles
	
Moghe${kmer}SamFiles :
	mkdir Moghe${kmer}SamFiles

#Get Files


${GSNAP_dir}/Moghe_${kmer} : ${RapGenomeData_dir}/RrContigs.fa.fasta
	gmap_build -d $@ -k ${kmer} $^	
	
${GSNAP_dir}/Sat_Chloro_${kmer} : ${SatGenomeData_dir}/Rsativus_chloroplast.fa	
	gmap_build -d $@ -k ${kmer} $^
	
${GSNAP_dir}/Sat_${kmer} : ${SatGenomeData_dir}/RSA_r1.0	
	gmap_build -d $@ -k ${kmer} $^
