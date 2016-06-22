#!/bin/bash
[ $# -ne 2 ] && echo "Summarize genomic targets in a bed file. This script will summarize targets found in file 'BED' and write the results to file 'OUT.OUT' and 'OUT'.png." && echo "Usage: $(basename $0) BED OUT" && echo "Instead of: $(basename $0) $*"  && exit 1

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BED=$1
OUT=$2

# summarize
cat $1 | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files \
$BASEDIR/annotation/mm10/ensGene77.type_rRNA.ucsc.gff.bed \
$BASEDIR/annotation/mm10/mm10_tRNAgenes.ucsc.gff.bed \
$BASEDIR/annotation/mm10/ensGene77.type_snoRNA.ucsc.gff.bed \
$BASEDIR/annotation/mm10/ensGene77.type_snRNA.ucsc.gff.bed \
$BASEDIR/annotation/mm10/ensGene77.type_lincRNA.ucsc.gff.bed \
$BASEDIR/annotation/mm10/ensGene77.type_misc_ncRNA.ucsc.gff.bed \
$BASEDIR/annotation/mm10/ensGene77.type_pseudogene.ucsc.gff.bed \
$BASEDIR/annotation/mm10/mm10_ensGene_3utr.bed \
$BASEDIR/annotation/mm10/mm10_ensGene_5utr.bed \
$BASEDIR/annotation/mm10/mm10_ensGene_codex.bed \
$BASEDIR/annotation/mm10/mm10_ensGene_introns.bed \
$BASEDIR/annotation_antisense.bed \
-names rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene 3UTR 5UTR exon intron antisense | \
$BASEDIR/bin/countAnnot.pl | \
$BASEDIR/bin/colAdd.sh $BED > $OUT.csv

# plot
cat $BASEDIR/bin/plotGenomicTargets.R | \
R --slave --args \
$OUT.csv $OUT \
rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene 3UTR 5UTR exon intron antisense \
not_annotated
