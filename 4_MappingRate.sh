for alignrun in `ls -d *[BG][TS]/`
do
for bamfile in `ls ${alignrun}*sorted.bam`
do samtools view -c -F 4 ${bamfile} 
done > ${alignrun}Aligned_reads.txt
done

for alignrun in `ls -d *[BG][TS]/`
do
for bamfile in `ls ${alignrun}*sorted.bam`
do samtools flagstat ${bamfile} 
done > ${alignrun}flagstat.txt
done

for alignrun in `ls -d *[BG][TS]/`
do
for bamfile in `ls ${alignrun}*sorted.bam`
do samtools stats ${bamfile} 
done > ${alignrun}stats.txt
done