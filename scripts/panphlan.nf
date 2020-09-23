#!/usr/bin/env nextflow
/**
 * usage: usage: panphlan.nf --run_table=fullList2.tsv
 **/
 
params.cpus = 20
params.out_dir = '/shared/homes/12705859/panphlan/parallel_mappings'
params.raw_dir = '.'
 
this_ch = Channel.fromPath(params.run_table)
    .splitCsv(header: true, sep: '\t', strip: true)
    .map{[file("${it['references']}"), file("${it['reads_paths']}"), file("${it['pangenome']}"), file("${it['index']}")]}
    

process panphlanmapping {

	conda 'panphlan bowtie2 samtools'
	
	cpus = params.cpus

	publishDir params.out_dir, mode:'copy'
	
	input:
	set references, pangenome, reads_paths, index from this_ch

    output:
    file "*" into myout
    
    """
    #!/bin/bash
    
    filename1=\$(basename $references)
    J="\${filename1%.*}"

    filename=\$(basename $reads_paths)
    N="\${filename%.*}"
    
    panphlan_map.py -i $reads_paths --index $index -p $pangenome -o \$J\\_\$N.csv --nproc ${params.cpus}

    """

}


nextflow run panphlan.nf --run_table=fullList2.tsv -resume



$ nano run_panphlanNF.sh

```
#!/bin/bash
#PBS -l ncpus=56
#PBS -l walltime=150:00:00
#PBS -l mem=150g
#PBS -N run_panphlanNF
#PBS -M daniela.gaio@student.uts.edu.au

cd /shared/homes/12705859/CARD_databases

nextflow run panphlan.nf --run_table=fullList.tsv
```

