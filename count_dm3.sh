#!/bin/bash
[ $# -ne 2 ] && echo "Summarize genomic targets in a bed file. This script will summarize targets found in file 'BED' and write the results to file 'OUTCSV'." && echo "Usage: $(basename $0) BED OUTCSV" && echo "Instead of: $(basename $0) $*"  && exit 1

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BED=$1
CSV=$2

cat $1 | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files \
#!/bin/bash
[ $# -ne 2 ] && echo "Summarize genomic targets in a bed file. This script will summarize targets found in file 'BED' and write the results to file 'OUTCSV'." && echo "Usage: $(basename $0) BED OUTCSV" && echo "Instead of: $(basename $0) $*"  && exit 1

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BED=$1
CSV=$2

cat $1 | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files \
$BASEDIR/annotation/dm3/dm3_refGene_whole_gene_rox1.bed \
$BASEDIR/annotation/dm3/dm3_refGene_whole_gene_rox2.bed \
$BASEDIR/annotation/dm3/dm3_refGene_whole_gene_CR41602.bed \
$BASEDIR/annotation/dm3/ensembl_rrna.ucsc.gff.bed \
$BASEDIR/annotation/dm3/ensembl_snorna.ucsc.gff.bed \
$BASEDIR/annotation/dm3/ensembl_snrna.ucsc.gff.bed \
$BASEDIR/annotation/dm3/ensembl_ncrna.ucsc.gff.bed \
$BASEDIR/annotation/dm3/ensembl_trna.ucsc.gff.bed \
$BASEDIR/annotation/dm3/ensGene_3utr.bed \
$BASEDIR/annotation/dm3/ensGene_5utr.bed \
$BASEDIR/annotation/dm3/ensGene_codex.bed \
$BASEDIR/annotation/dm3/ensGene_introns.bed \
$BASEDIR/annotation_antisense_dm3.bed \
-names rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene protcod_as 3UTR 5UTR exon intron antisense | \
$BASEDIR/bin/countAnnot.pl | \
$BASEDIR/bin/colAdd.sh $BED > $CSV
