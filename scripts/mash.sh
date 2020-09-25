##########################
## execution example (run for Fe7)
## export reference_file_with_path=/shared/homes/12705859/mash_test/probiotic_references/reference.msh
## export thepaths=mypaths_Fe7.tsv
## export ncpus=20
## qsub -V mash.sh
##########################

#!/bin/bash
#PBS -l ncpus=22
#PBS -l walltime=200:00:00
#PBS -l mem=50g
#PBS -N mash.sh
#PBS -M daniela.gaio@student.uts.edu.au

source activate mash_env

cd /shared/homes/12705859/mash_test/probiotic_references/out

while read line
do 
filename=$(basename $line)
N="${filename%.*}"
mash screen -p $ncpus $reference_file_with_path $line > screen\_$N.tab
done < $thepaths





export reference_file_with_path=/shared/homes/12705859/mash_test/probiotic_references/reference.msh
export thepaths=mypaths_Fe7.tsv
export ncpus=20
qsub -V mash.sh

export reference_file_with_path=/shared/homes/12705859/mash_test/probiotic_references/reference.msh
export thepaths=mypaths_Ja31.tsv
export ncpus=20
qsub -V mash.sh

export reference_file_with_path=/shared/homes/12705859/mash_test/probiotic_references/reference.msh
export thepaths=mypaths_Fe14.tsv
export ncpus=20
qsub -V mash.sh

export reference_file_with_path=/shared/homes/12705859/mash_test/probiotic_references/reference.msh
export thepaths=mypaths_Fe21.tsv
export ncpus=20
qsub -V mash.sh

export reference_file_with_path=/shared/homes/12705859/mash_test/probiotic_references/reference.msh
export thepaths=mypaths_Fe28.tsv
export ncpus=20
qsub -V mash.sh






