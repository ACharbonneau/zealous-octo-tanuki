#!/bin/bash

rm *background*
## Run from DEseqOutput folder

for i in */*deseq2_FC0_HvL.csv; do cut -f 1 -d "," ${i} | tail -n +2 > $i.genes; done

for i in Jeong2016_*/*csv.genes
do grep -f ${i} -A 1 ../Genomes/Jeong2016/Rs_1.0.cds.fa > ${i}.fa
done

blastn -db ../Indicies/MitsuiGenes -query Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL.csv.genes.fa -out Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10

for i in Kitashiba2014_*/*csv.genes
do cut -f 2 -d ":" ${i} > ${i}.edit
done

for i in Kitashiba2014_*/*csv.genes.edit
do grep -f ${i} -A 1 ../Genomes/Kitashiba2014/RSA_r1.0_cds > ${i}.fa
done

blastn -db ../Indicies/MitsuiGenes -query Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_HvL.csv.genes.edit.fa -out Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10


for i in Mitsui2015_*/*csv.genes
do grep -f ${i} -A 1 ../Genomes/Mitsui2015/rsgm_nav1.fasta > ${i}.fa
done

for i in Moghe2014_*/*csv.genes
do cut -f 1 -d "-" ${i} > ${i}.edit
done

for i in Moghe2014_*/*csv.genes.edit
do grep -f ${i} -A 1 ../Genomes/Moghe2014/RrCDS.fa > ${i}.fa
done

blastn -db ../Indicies/MitsuiGenes -query Moghe2014_GS/Moghe2014_GS_deseq2_FC0_HvL.csv.genes.edit.fa -out Moghe2014_GS/Moghe2014_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10


for i in RR3NYEST_*/*csv.genes
do grep -f ${i} -A 1 ../Genomes/RR3NYEST/RR3_NY/1000017.fa > ${i}.fa
done

blastn -db ../Indicies/MitsuiGenes -query RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_HvL.csv.genes.fa -out RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10

for i in *_GS/*FC0_HvL_AsMitsui.list
do cut -f 2 -d "," ${i} > `basename ${i} .list`.names
done

sed 's/$/.t1/' Mitsui2015_GS/Mitsui2015_GS_deseq2_FC0_HvL.csv.genes > Mitsui2015_GS_deseq2_FC0_HvL_AsMitsui.names

for i in *_HvL_AsMitsui.names
do cut -f 1,2 -d "," ${i} | uniq > ${i}.uniq
done

## Make Background gene Lists

cat ../Jeong2016_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" > Jeong2016_GS_background
cat ../RR3NYEST_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" > RR3NYEST_GS_background
cat ../Moghe2014_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" | cut -f 1 -d "-" > Moghe2014_GS_background
cat ../Kitashiba2014_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" | cut -f 2 -d ":" > Kitashiba2014_GS_background
cat ../Mitsui2015_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" > Mitsui2015_GS_background

#There's a bunch of errors in the Rs_1.0.cds.fa. It has a # instead of a > for a handful of lines. Fix:
sed -i 's/#/>/g' ../Genomes/Jeong2016/Rs_1.0.cds.fa

#One of the gene names is wrong in the background file...presumably from the gff
sed -i 's/\.1//'
xargs samtools faidx ../Genomes/Jeong2016/Rs_1.0.cds.fa  < Jeong2016_GS_background >> Jeong2016_GS_background.fa
xargs samtools faidx ../Genomes/RR3NYEST/RR3_NY/1000017.fa  < RR3NYEST_GS_background >> RR3NYEST_GS_background.fa
xargs samtools faidx ../Genomes/Moghe2014/RrCDS.fa  < Moghe2014_GS_background >> Moghe2014_GS_background.fa
xargs samtools faidx ../Genomes/Kitashiba2014/RSA_r1.0_cds  < Kitashiba2014_GS_background >> Kitashiba2014_GS_background.fa

blastn -db ../Indicies/MitsuiGenes -query Jeong2016_GS_background.fa -out Jeong2016_GS_background_AsMitsui.names -max_target_seqs 1 -outfmt 10
blastn -db ../Indicies/MitsuiGenes -query RR3NYEST_GS_background.fa -out RR3NYEST_GS_background_AsMitsui.names -max_target_seqs 1 -outfmt 10
blastn -db ../Indicies/MitsuiGenes -query Moghe2014_GS_background.fa -out Moghe2014_GS_background_AsMitsui.names -max_target_seqs 1 -outfmt 10
blastn -db ../Indicies/MitsuiGenes -query Kitashiba2014_GS_background.fa -out Kitashiba2014_GS_background_AsMitsui.names -max_target_seqs 1 -outfmt 10
sed 's/$/.t1/' Mitsui2015_GS_background > Mitsui2015_GS_background_AsMitsui.names

for i in *_background_AsMitsui.names
do cut -f 1,2 -d "," ${i} | uniq > ${i}.uniq
done
