
# run bwa mem of probiotics+pigBins against reads from date of interest (here: 170207)
 

#!/bin/bash
#PBS -l ncpus=36
#PBS -l walltime=150:00:00
#PBS -l mem=200g
#PBS -N run_bwa_mem
#PBS -M daniela.gaio@student.uts.edu.au


for i in `ls /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/out/*.fa`
do 
filename=$(basename $i)   
N="${filename%.*}"
bwa mem -p $i /shared/homes/s1/pig_microbiome/out_new/$N/reads/$N-170207-01_cleaned_paired.fq.gz > /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/out/$N.sam
done