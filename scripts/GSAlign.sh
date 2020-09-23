#!/bin/bash
#PBS -l ncpus=12
#PBS -l walltime=48:00:00
#PBS -l mem=20g
#PBS -N GSAlign
#PBS -M daniela.gaio@student.uts.edu.au

source activate gsalign_env

cd /shared/homes/12705859/prob_Hunt/outdir/probi/GSAlign

for i in `ls GSAlign_refs/*`
do 
filename=$(basename $i)     
N="${filename%.*}"
for j in `ls GSAlign_queries/*`
do
filename2=$(basename $j)     
J="${filename2%.*}"
GSAlign -alen 100 -t 10 -one -r $i -q $j -o out/$J"__ref"$N
done
done





