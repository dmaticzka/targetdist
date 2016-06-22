#!/bin/bash
[ $# -ne 2 ] && echo "Summarize genomic targets in a bed file. This script will summarize targets found in file 'BED' and write the results to file 'OUTCSV'." && echo "Usage: $(basename $0) BED OUTCSV" && echo "Instead of: $(basename $0) $*"  && exit 1

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BED=$1
CSV=$2

cat $1 | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files \
annotation/hg19/type_rRNA.bed \
annotation/hg19/tRNAgenes.bed \
annotation/hg19/type_snoRNA.bed \
annotation/hg19/type_snRNA.bed \
annotation/hg19/type_lincRNA.bed \
annotation/hg19/type_misc_ncRNA.bed \
annotation/hg19/type_pseudogene.bed \
annotation/hg19/type_protein_coding_antisense.bed \
annotation/hg19/3utr.bed \
annotation/hg19/5utr.bed \
annotation/hg19/codex.bed \
annotation/hg19/introns.bed \
annotation_antisense.bed \
-names rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene protcod_as 3UTR 5UTR exon intron antisense | \
bin/countAnnot.pl | \
bin/colAdd.sh $BED > $CSV
