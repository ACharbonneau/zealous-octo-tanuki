#! /bin/bash

echo "1. Getting data"
cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq/cel*/*.tar.gz .

echo "2. Untar"
for i in `ls *.tar.gz`; do tar -zxvf ${i}; done

#Rename to format: Cel_Date_Lane_PlantID.filetype

echo "3. Rename files"
sh scripts/RenameAE_rawfiles.sh

echo "4. Convert fna to fastq"
rm *_ID*
for i in `ls *.fna`; do perl zealous-octo-tanuki/fastaQual2fastq.pl ${i}; done
for i in `ls *.fastq`; do cat ${i} | sed s/\!$// > ${i}.edit; echo ${i}; done

echo "5. Clean up directory"
rm -r `ls -d 20081*/`
rm *.tar.gz
mkdir OriginalFiles
mv *.fna OriginalFiles/
mv *.qual OriginalFiles/
rm *.fastq
mkdir fastqc
mkdir BowtieIndicies

echo "6. Get metadata"
mkdir metadata
cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq/cel6/SeqProductionSumm.xls metadata/SeqProductionSumm.xls
grep -c "@30" *.fastq.edit > metadata/totalreads.txt
cd metadata
cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq_metadata/Exs\ QTL\ parents.xls .
cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq_metadata/HTanalysisInputForR.csv .
cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq_metadata/DifferentialGenesPseudoInputForR.csv .
cp /mnt/research/radishGenomics/OriginalSequencingFiles/2008_AE_RNAseq_metadata/metadata.csv .

qsub zealous-octo-tanuki/2_FastQC.qsub

echo "Data Acquired"
