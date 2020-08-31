
# concatenate the probiotic strains fasta files to the piglets (and not only) bins 

#!/bin/bash
#PBS -l ncpus=6
#PBS -l walltime=48:00:00
#PBS -l mem=100g
#PBS -N concatenating_prob_to_pigIDsBins
#PBS -M daniela.gaio@student.uts.edu.au

for i in `ls /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/*.fa`
do
N=$(basename $i)
cat /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/probiotics.fasta $i > /shared/homes/12705859/prob_Hunt/outdir/concatenate_to_probiotics/out/$N
done