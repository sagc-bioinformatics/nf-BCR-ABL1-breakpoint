
nextflow.enable.dsl=2

params.outdir = '/Users/jimmy.breen/Downloads/results'

// factera is separate
params.factera = '/apps/bioinfo/custom_local/factera/factera.pl'

// custom refs
params.exons = '/apps/bioinfo/share/bcbio/genomes/Hsapiens/GRCh37/rnaseq/exons.hg19.bed'
params.bitRef = '/apps/bioinfo/share/bcbio/genomes/Hsapiens/hg38/ucsc/hg38.2bit'
params.bwa_idx = ''

include { markDupSambamba } from './modules/sambamba/0.7.1/RunSambambaMarkDup'
include { BwaMapSortedBam } from './modules/bwa/0.7.17/BwaMapSortedBam.nf'


workflow {

    ch_reads = Channel.fromFilePairs('data/*_R{1,2}.fastq.gz')

    // Genome files
	ch_exon = file(params.exons)
	ch_genome = file(params.reference)
    ch_bitRef = file(params.bitRef)

    // will needs some samtools flagstats in here

    BwaMapSortedBam(params.bwa_idx, ch_reads)
    markDupSambamba(BwaMapSortedBam.out)
    factera(params.factera, markDupSambamba.out, ch_exon, params.bitRef)

}