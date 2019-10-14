# eCLIP_deduplication
The eclip pipline here is according to the reference "Robust transcriptome-wide discovery of rnA-binding protein binding sites with enhanced CLIP (eCLIP)" by Gene Yeo's lab.

Note that barcode on each read need to be trimmed during the cut adapter process (as shown in cutadapt_eclip.sh)

remove_redundant_in_bam.pl is then used to remove duplicated reads in bam files

perl remove_redundant_in_bam.pl input.fastq input.bam output.bam
