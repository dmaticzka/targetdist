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
$BASEDIR/annotation/dm3/ensembl_rrna.ucsc.gff.bed.gz \
$BASEDIR/annotation/dm3/ensembl_snorna.ucsc.gff.bed.gz \
$BASEDIR/annotation/dm3/ensembl_snrna.ucsc.gff.bed.gz \
$BASEDIR/annotation/dm3/ensembl_ncrna.ucsc.gff.bed.gz \
$BASEDIR/annotation/dm3/ensembl_trna.ucsc.gff.bed.gz \
$BASEDIR/annotation/dm3/ensGene_3utr.bed.gz \
$BASEDIR/annotation/dm3/ensGene_5utr.bed.gz \
$BASEDIR/annotation/dm3/ensGene_codex.bed.gz \
$BASEDIR/annotation/dm3/ensGene_introns.bed.gz \
$BASEDIR/annotation/dm3/annotation_antisense_dm3.bed.gz \
-names rRNA snoRNA snRNA ncRNA tRNA 3UTR 5UTR exon intron antisense | \
$BASEDIR/bin/countAnnot.pl | \
$BASEDIR/bin/colAdd.sh $BED > $OUT.csv

# plot
cat $BASEDIR/bin/plotGenomicTargets.R | \
R --slave --args \
$OUT.csv $OUT \
rRNA snoRNA snRNA ncRNA tRNA 3UTR 5UTR exon intron antisense \
not_annotated
