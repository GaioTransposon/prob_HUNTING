##########################
## execution example (run for Fe7)
## export theoutputdir=all_mappings/panphlan_mapping_Fe7
## export thepaths=mypaths_Fe7.tsv
## export thereferences=myrefs.tsv
## qsub -V panphlan_mapping.sh
##########################

#!/bin/bash
#PBS -l ncpus=22
#PBS -l walltime=200:00:00
#PBS -l mem=50g
#PBS -N panphlan_mapping
#PBS -M daniela.gaio@student.uts.edu.au

source activate panphlan_env

cd /shared/homes/12705859/panphlan

while read reference
do 
filename1=$(basename $reference)
J="${filename1%.*}"
while read line
do 
filename=$(basename $line)
N="${filename%.*}"
panphlan_map.py -i $line --index $reference/$reference -p $reference/$reference*.tsv -o $theoutputdir/$J\_$N.csv --nproc 20
done < $thepaths
done < $thereferences
