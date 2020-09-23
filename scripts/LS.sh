#!/bin/bash
#PBS -l ncpus=56
#PBS -l walltime=48:00:00
#PBS -l mem=20g
#PBS -M daniela.gaio@student.uts.edu.au

source activate panphlan_env

cd /shared/homes/12705859/panphlan

while read line
do 
filename=$(basename $line)     
N="${filename%.*}"
panphlan_map.py -i $line --index Lactobacillus_salivarius/Lactobacillus_salivarius -p Lactobacillus_salivarius/Lactobacillus_salivarius*.tsv -o map_results/$N.csv --nproc  54
done < mypaths.tsv