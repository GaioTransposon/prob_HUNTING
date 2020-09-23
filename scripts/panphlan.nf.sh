#!/usr/bin/env nextflow
/**
 * usage: usage: panphlan.nf --run_table=fullList2.tsv
 **/
 
params.cpus = 20
params.out_dir = '/shared/homes/12705859/panphlan/parallel_mappings'
params.raw_dir = '.'
 
this_ch = Channel.fromPath(params.run_table)
    .splitCsv(header: true, sep: '\t', strip: true)
    .map{[file("${it['references']}"), file("${it['pangenome']}"), file("${it['index']}")]}
    
other_ch = Channel.fromPath(params.run_table)
    .splitCsv(header: true, sep: '\t', strip: true)
    .map{[file("${it['reads_paths']}")]}
    
process panphlanmapping {

	conda 'panphlan bowtie2 samtools'
	
	cpus = params.cpus

	publishDir params.out_dir, mode:'copy'
	
	input:
	set references, pangenome, reads_paths, index from this_ch
	file reads_paths from other_ch.buffer(size=5, remainder: true)

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
