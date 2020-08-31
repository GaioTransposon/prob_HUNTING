
# run bwa mem of probiotics+pigBins against reads from date of interest (here: 170214)
 

#!/bin/bash
#PBS -l ncpus=24
#PBS -l walltime=200:00:00
#PBS -l mem=100g
#PBS -N run_bwaMemFe14
#PBS -M daniela.gaio@student.uts.edu.au


for i in `ls /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/out_Fe7/*.fa`
do 
filename=$(basename $i)   
N="${filename%.*}"
bwa mem -p $i /shared/homes/s1/pig_microbiome/out_new/$N/reads/$N-170214-01_cleaned_paired.fq.gz > /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/out_Fe14/$N.sam
done