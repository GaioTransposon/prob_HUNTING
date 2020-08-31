
# run indexing of the probiotics+pigBins fasta files
 

#!/bin/bash
#PBS -l ncpus=6
#PBS -l walltime=48:00:00
#PBS -l mem=100g
#PBS -N run_indexing
#PBS -M daniela.gaio@student.uts.edu.au


for i in `ls /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/out/*.fa`
do 
bwa index $i 
done