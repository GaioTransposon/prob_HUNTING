##########################
## execution example (run for Fe7)
## export mapping_dir=/shared/homes/12705859/panphlan/all_mappings/panphlan_mapping_Fe7
## qsub -V panphlan_profiling.sh
##########################

#!/bin/bash
#PBS -l ncpus=40
#PBS -l walltime=48:00:00
#PBS -l mem=20g
#PBS -N panphlan_profiling
#PBS -M daniela.gaio@student.uts.edu.au

source activate panphlan_env

# enter the directory where the mapping results are: 
cd $mapping_dir
mkdir matrix_out

mkdir map_BB  
mv Bifidobacterium_bifidum_* /map_BB/.

mkdir map_EF  
mv Enterococcus_faecium_* /map_EF/.

mkdir map_LAc  
mv Lactobacillus_acidophilus_* /map_LAc/.

mkdir map_LAm  
mv Lactobacillus_amylovorus_* /map_LAm/.

mkdir map_LD  
mv Lactobacillus_delbrueckii_* /map_LD/.

mkdir map_LH  
mv Lactobacillus_helveticus_* /map_LH/.

mkdir map_LR  
mv Lactobacillus_rhamnosus_* /map_LR/.

mkdir map_LS  
mv Lactobacillus_salivarius_* /map_LS/.

mkdir map_ST
mv Streptococcus_thermophilus_* /map_ST/.


panphlan_profiling.py -p /shared/homes/12705859/panphlan/Bifidobacterium_bifidum/Bifidobacterium_bifidum_pangenome.tsv -i map_BB/ --o_matrix ./matrix_out/profile_BB --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Lactobacillus_amylovorus/Lactobacillus_amylovorus_pangenome.tsv -i map_LAm/ --o_matrix ./matrix_out/profile_LAm --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Lactobacillus_helveticus/Lactobacillus_helveticus_pangenome.tsv -i map_LH/ --o_matrix ./matrix_out/profile_LH --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Lactobacillus_delbrueckii/Lactobacillus_delbrueckii_pangenome.tsv -i map_LD/ --o_matrix ./matrix_out/profile_LD --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Lactobacillus_rhamnosus/Lactobacillus_rhamnosus_pangenome.tsv -i map_LR/ --o_matrix ./matrix_out/profile_LR --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Lactobacillus_salivarius/Lactobacillus_salivarius_pangenome.tsv -i map_LS/ --o_matrix ./matrix_out/profile_LS --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Streptococcus_thermophilus/Streptococcus_thermophilus_pangenome.tsv -i map_ST/ --o_matrix ./matrix_out/profile_ST --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Enterococcus_faecium/Enterococcus_faecium_pangenome.tsv -i map_EF/ --o_matrix ./matrix_out/profile_EF --min_coverage 1 --left_max 1.70 --right_min 0.30

panphlan_profiling.py -p /shared/homes/12705859/panphlan/Lactobacillus_acidophilus/Lactobacillus_acidophilus_pangenome.tsv -i map_LAc/ --o_matrix ./matrix_out/profile_LAc --min_coverage 1 --left_max 1.70 --right_min 0.30
# this is not working for Fe7 samples , index out of range 


# this is the least stringent option: --min_coverage 1 --left_max 1.70 --right_min 0.30

