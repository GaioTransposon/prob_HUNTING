#!/bin/bash
#PBS -l ncpus=56
#PBS -l walltime=72:00:00
#PBS -l mem=20g
#PBS -M daniela.gaio@student.uts.edu.au

source activate mash_env

cd /shared/homes/12705859/mash_test/mash_vs_assemblies
 
# write sketches for the assemblies
for assembly in `ls /shared/homes/12705859/out_new_without_depth/contigs/*.fa`
do
mash sketch $assembly
done 

# calculate distance
for assembly in `ls /shared/homes/12705859/out_new_without_depth/contigs/*.fa`
do 
mash dist /shared/homes/12705859/mash_test/probiotic_references/Lactobacillus_acidophilus_NCIMB701748_ATCC4356.contigs.fasta $assembly > "Lactobacillus_acidophilus_NCIMB701748_ATCC4356__$(basename "$assembly").csv"
mash dist /shared/homes/12705859/mash_test/probiotic_references/Lactobacillus_delbrueckii_NCIMB11778_ATCC11842.contigs.fasta $assembly > "Lactobacillus_delbrueckii_NCIMB11778_ATCC11842__$(basename "$assembly").csv"
mash dist /shared/homes/12705859/mash_test/probiotic_references/Lactobacillus_plantarum_140318.contigs.fasta $assembly > "Lactobacillus_plantarum_140318__$(basename "$assembly").csv"; 
mash dist /shared/homes/12705859/mash_test/probiotic_references/Lactobacillus_plantarum_NCIMB11974_ATCC14917.contigs.fasta $assembly > "Lactobacillus_plantarum_NCIMB11974_ATCC14917__$(basename "$assembly").csv"
mash dist /shared/homes/12705859/mash_test/probiotic_references/Lactobacillus_rhamnosus_NCIMB8010_ATCC7469.contigs.fasta $assembly > "Lactobacillus_rhamnosus_NCIMB8010_ATCC7469__$(basename "$assembly").csv"
mash dist /shared/homes/12705859/mash_test/probiotic_references/Lactobacillus_salivarius_140318.contigs.fasta $assembly > "Lactobacillus_salivarius_140318__$(basename "$assembly").csv"; 
done

