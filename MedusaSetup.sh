Kitashiba2014="/mnt/research/radishGenomics/PublicData/RsativusGenome/Edit_RSA_r1.0"
Mitsui2015="/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsg_all_v1.fasta"
Moghe2014="/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/RrContigs.fa.fasta"
Jeong2016="/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Rs_1.0.chromosomes.fix.fasta"


mkdir Medusa3Assembly
mkdir Medusa4Assembly
mkdir Medusa3Assembly/drafts
mkdir Medusa4Assembly/drafts

cp -r medusa/medusa_scripts/ Medusa3Assembly
cp -r medusa/medusa_scripts/ Medusa4Assembly

cp medusa/medusa.jar Medusa3Assembly
cp medusa/medusa.jar Medusa4Assembly

cp $Mitsui2015 Medusa3Assembly/ && mv Medusa3Assembly/rsg_all_v1.fasta Medusa3Assembly/Mitsui2015
cp $Kitashiba2014 Medusa3Assembly/drafts/ && mv Medusa3Assembly/drafts/Edit_RSA_r1.0 Medusa3Assembly/drafts/Kitashiba2014
cp $Jeong2016 Medusa3Assembly/drafts/ && mv Medusa3Assembly/drafts/Rs_1.0.chromosomes.fix.fasta Medusa3Assembly/drafts/Jeong2016

cp $Moghe2014 Medusa4Assembly/ && mv Medusa4Assembly/RrContigs.fa.fasta Medusa4Assembly/Moghe2014
cp $Kitashiba2014 Medusa4Assembly/drafts/ && mv Medusa4Assembly/drafts/Edit_RSA_r1.0 Medusa4Assembly/drafts/Kitashiba2014
cp $Mitsui2015 Medusa4Assembly/drafts/ && mv Medusa4Assembly/drafts/rsg_all_v1.fasta Medusa4Assembly/drafts/Mitsui2015
cp $Jeong2016 Medusa4Assembly/drafts/ && mv Medusa4Assembly/drafts/Rs_1.0.chromosomes.fix.fasta Medusa4Assembly/drafts/Jeong2016



