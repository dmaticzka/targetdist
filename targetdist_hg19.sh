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
$BASEDIR/annotation/hg19/type_rRNA.bed \
$BASEDIR/annotation/hg19/tRNAgenes.bed \
$BASEDIR/annotation/hg19/type_snoRNA.bed \
$BASEDIR/annotation/hg19/type_snRNA.bed \
$BASEDIR/annotation/hg19/type_lincRNA.bed \
$BASEDIR/annotation/hg19/type_misc_ncRNA.bed \
$BASEDIR/annotation/hg19/type_pseudogene.bed \
$BASEDIR/annotation/hg19/type_protein_coding_antisense.bed \
$BASEDIR/annotation/hg19/3utr.bed \
$BASEDIR/annotation/hg19/5utr.bed \
$BASEDIR/annotation/hg19/codex.bed \
$BASEDIR/annotation/hg19/introns.bed \
$BASEDIR/annotation/hg19/annotation_antisense_hg19.bed \
-names rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene protcod_as 3UTR 5UTR exon intron antisense | \
$BASEDIR/bin/countAnnot.pl | \
$BASEDIR/bin/colAdd.sh $BED > $OUT.csv

# plot
cat $BASEDIR/bin/plotGenomicTargets.R | \
R --slave --args \
$OUT.csv $OUT \
rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene protcod_as 3UTR 5UTR exon intron antisense \
not_annotated
