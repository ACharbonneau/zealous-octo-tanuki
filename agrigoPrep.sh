Kitashiba2014Kitashiba2014#!/bin/bash

#There's a bunch of errors in the Rs_1.0.cds.fa. It has a # instead of a > for a handful of lines. Fix:
sed -i 's/#/>/g' ../Genomes/Jeong2016/Rs_1.0.cds.fa

rm *background*
## Run from DEseqOutput folder

cut -f 1 -d "," Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL.csv | tail -n +2 > $i.genes; done

for i in Jeong2016_GS/*deseq2_FC0_*.csv.genes; do xargs samtools faidx ../Genomes/Jeong2016/Rs_1.0.cds.fa  < ${i} >> ${i}.fa ; done

blastn -db ../Indicies/MitsuiGenes -query Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL.csv.genes.fa -out Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10

blastn -db ../Indicies/MitsuiGenes -query Jeong2016_GS/Jeong2016_GS_deseq2_FC0_KvR.csv.genes.fa -out Jeong2016_GS/Jeong2016_GS_deseq2_FC0_KvR_AsMitsui.list -max_target_seqs 1 -outfmt 10

cut -f 1,3 -d "," Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep "-" | cut -f 1 -d "," > Jeong2016_down.txt
grep -f Jeong2016_down.txt Jeong2016_GS_background_AsMitsui.names | cut -f 2 -d "," > Jeong2016_down_asMitsui.txt
cut -f 1,3 -d "," Jeong2016_GS/Jeong2016_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep -v "-" | cut -f 1 -d "," | grep -v "^$" > Jeong2016_up.txt
grep -f Jeong2016_up.txt Jeong2016_GS_background_AsMitsui.names | cut -f 2 -d "," > Jeong2016_up_asMitsui.txt


for i in Kitashiba2014_*/*csv.genes
do cut -f 2 -d ":" ${i} > ${i}.edit
done

for i in Kitashiba2014_GS/*deseq2_FC0_*.csv.genes.edit; do xargs samtools faidx ../Genomes/Kitashiba2014/RSA_r1.0_cds  < ${i} >> ${i}.fa ; done

blastn -db ../Indicies/MitsuiGenes -query Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_HvL.csv.genes.edit.fa -out Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10

blastn -db ../Indicies/MitsuiGenes -query Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_KvR.csv.genes.edit.fa -out Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_KvR_AsMitsui.list -max_target_seqs 1 -outfmt 10

cut -f 1,3 -d "," Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep "-" | cut -f 1 -d "," > Kitashiba2014_down.txt
grep -f Kitashiba2014_down.txt Kitashiba2014_GS_background_AsMitsui.names | cut -f 2 -d "," > Kitashiba2014_down_asMitsui.txt
cut -f 1,3 -d "," Kitashiba2014_GS/Kitashiba2014_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep -v "-" | cut -f 1 -d "," | grep -v "^$" > Kitashiba2014_up.txt
grep -f Kitashiba2014_up.txt Kitashiba2014_GS_background_AsMitsui.names | cut -f 2 -d "," > Kitashiba2014_up_asMitsui.txt


for i in Mitsui2015_GS/*deseq2_FC0_*.csv.genes; do xargs samtools faidx ../Genomes/Mitsui2015/rsgm_nav1.fa  < ${i} >> ${i}.fa ; done
cut -f 1,3 -d "," Mitsui2015_GS/Mitsui2015_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep "-" | cut -f 1 -d "," > Mitsui2015_down.txt
cut -f 1,3 -d "," Mitsui2015_GS/Mitsui2015_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep -v "-" | cut -f 1 -d "," | grep -v "^$" > Mitsui2015_up.txt


for i in Moghe2014_*/*csv.genes
do cut -f 1 -d "-" ${i} > ${i}.edit
done

for i in Moghe2014_GS/*deseq2_FC0_*.csv.genes.edit; do xargs samtools faidx ../Genomes/Moghe2014/RrCDS.fa  < ${i} >> ${i}.fa ; done

blastn -db ../Indicies/MitsuiGenes -query Moghe2014_GS/Moghe2014_GS_deseq2_FC0_HvL.csv.genes.edit.fa -out Moghe2014_GS/Moghe2014_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10

blastn -db ../Indicies/MitsuiGenes -query Moghe2014_GS/Moghe2014_GS_deseq2_FC0_KvR.csv.genes.edit.fa -out Moghe2014_GS/Moghe2014_GS_deseq2_FC0_KvR_AsMitsui.list -max_target_seqs 1 -outfmt 10

cut -f 1,3 -d "," Moghe2014_GS/Moghe2014_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep "-" | cut -f 1 -d "," > Moghe2014_down.txt
grep -f Moghe2014_down.txt Moghe2014_GS_background_AsMitsui.names | cut -f 2 -d "," > Moghe2014_down_asMitsui.txt
cut -f 1,3 -d "," Moghe2014_GS/Moghe2014_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep -v "-" | cut -f 1 -d "," | grep -v "^$" > Moghe2014_up.txt
grep -f Moghe2014_up.txt Moghe2014_GS_background_AsMitsui.names | cut -f 2 -d "," > Moghe2014_up_asMitsui.txt



for i in RR3NYEST_GS/*deseq2_FC0_*.csv.genes; do xargs samtools faidx ../Genomes/RR3NYEST/RR3_NY/1000017.fa  < ${i} >> ${i}.fa ; done

blastn -db ../Indicies/MitsuiGenes -query RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_HvL.csv.genes.fa -out RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_HvL_AsMitsui.list -max_target_seqs 1 -outfmt 10

blastn -db ../Indicies/MitsuiGenes -query RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_KvR.csv.genes.fa -out RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_KvR_AsMitsui.list -max_target_seqs 1 -outfmt 10

cut -f 1,3 -d "," RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep "-" | cut -f 1 -d "," > RR3NYEST_down.txt
grep -f RR3NYEST_down.txt RR3NYEST_GS_background_AsMitsui.names | cut -f 2 -d "," > RR3NYEST_down_asMitsui.txt
cut -f 1,3 -d "," RR3NYEST_GS/RR3NYEST_GS_deseq2_FC0_HvL.csv | sort  -nk2 -t "," | grep -v "-" | cut -f 1 -d "," | grep -v "^$" > RR3NYEST_up.txt
grep -f RR3NYEST_up.txt RR3NYEST_GS_background_AsMitsui.names | cut -f 2 -d "," > RR3NYEST_up_asMitsui.txt


for i in *_GS/*FC0_*_AsMitsui.list
do cut -f 2 -d "," ${i} > `basename ${i} .list`.names
done

sed 's/$/.t1/' Mitsui2015_GS/Mitsui2015_GS_deseq2_FC0_HvL.csv.genes > Mitsui2015_GS_deseq2_FC0_HvL_AsMitsui.names
sed 's/$/.t1/' Mitsui2015_GS/Mitsui2015_GS_deseq2_FC0_KvR.csv.genes > Mitsui2015_GS_deseq2_FC0_KvR_AsMitsui.names

for i in *_AsMitsui.names
do cut -f 1,2 -d "," ${i} | uniq > ${i}.uniq
done

## Make Background gene Lists

cat ../Jeong2016_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" > Jeong2016_GS_background
cat ../RR3NYEST_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" > RR3NYEST_GS_background
cat ../Moghe2014_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" | cut -f 1 -d "-" > Moghe2014_GS_background
cat ../Kitashiba2014_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" | cut -f 2 -d ":" > Kitashiba2014_GS_background
cat ../Mitsui2015_GS/*.counts.txt | egrep -v '\t0' | cut -f 1 | sort | uniq | grep -v "__" > Mitsui2015_GS_background


#One of the gene names is wrong in the background file...presumably from the gff
sed -i 's/\.1//' Jeong2016_GS_background

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
