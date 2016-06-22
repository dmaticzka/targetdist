# targetdist

Plot distribution over hierarchical sets of genomic targets.

## Requirements

* processing of library requires oldish bedtools for 'merge -nms', working with bioconda version 2.19.1
* r-ggplot2
* r-gridextra

## Notes

* countAnnot.pl requires

### Prepare annotation

Calls for downloading and preparing annotation. Creates annotation_antisense.bed in current directory. Has to be moved to annot dirs and used.

* hg19: `make test/test_hg19.genomic_targets`
* dm3: `make test/test_dm3.genomic_targets -e GENOME=dm3`
* mm10: `make test/test_mm10.genomic_targets -e GENOME=mm10`

### calls hg19

```
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_rRNA.gtf > annotation/hg19/type_rRNA.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/tRNAgenes.gtf > annotation/hg19/tRNAgenes.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_snoRNA.gtf > annotation/hg19/type_snoRNA.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_snRNA.gtf > annotation/hg19/type_snRNA.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_lincRNA.gtf > annotation/hg19/type_lincRNA.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_misc_ncRNA.gtf > annotation/hg19/type_misc_ncRNA.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_pseudogene.gtf > annotation/hg19/type_pseudogene.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/type_protein_coding_antisense.gtf > annotation/hg19/type_protein_coding_antisense.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/3utr.gtf > annotation/hg19/3utr.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/5utr.gtf > annotation/hg19/5utr.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/hg19/codex.gtf > annotation/hg19/codex.bed
cat annotation/hg19/type_rRNA.bed annotation/hg19/tRNAgenes.bed annotation/hg19/type_snoRNA.bed annotation/hg19/type_snRNA.bed annotation/hg19/type_lincRNA.bed annotation/hg19/type_misc_ncRNA.bed annotation/hg19/type_pseudogene.bed annotation/hg19/type_protein_coding_antisense.bed annotation/hg19/3utr.bed annotation/hg19/5utr.bed annotation/hg19/codex.bed annotation/hg19/introns.bed | \
cut -f 1-6 | \
bedtools sort -i - | \
bedtools merge -s -nms -n -i - | \
perl -ane '$F[5] =~ tr/+-/-+/; print join("\t", @F), "\n"' > annotation_antisense.bed
cat test/test_hg19.bed | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files annotation/hg19/type_rRNA.bed annotation/hg19/tRNAgenes.bed annotation/hg19/type_snoRNA.bed annotation/hg19/type_snRNA.bed annotation/hg19/type_lincRNA.bed annotation/hg19/type_misc_ncRNA.bed annotation/hg19/type_pseudogene.bed annotation/hg19/type_protein_coding_antisense.bed annotation/hg19/3utr.bed annotation/hg19/5utr.bed annotation/hg19/codex.bed annotation/hg19/introns.bed annotation_antisense.bed \
-names rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene protcod_as 3UTR 5UTR exon intron antisense | gzip > test/test_hg19.genomic_targets.bed_annot.gz
zcat test/test_hg19.genomic_targets.bed_annot.gz | bin/countAnnot.pl | bin/colAdd.sh test/test_hg19 > test/test_hg19.genomic_targets.csv
R --slave --args test/test_hg19.genomic_targets.csv test/test_hg19.genomic_targets rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene protcod_as 3UTR 5UTR exon intron antisense intergenic < bin/plotGenomicTargets.R && touch test/test_hg19.genomic_targets
```

### calls dm3

```
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/dm3/ensembl_snorna.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/dm3/ensembl_snorna.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/dm3/ensembl_ncrna.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/dm3/ensembl_ncrna.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/dm3/ensembl_trna.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/dm3/ensembl_trna.ucsc.gff.bed
cat annotation/dm3/dm3_refGene_whole_gene_rox1.bed annotation/dm3/dm3_refGene_whole_gene_rox2.bed annotation/dm3/dm3_refGene_whole_gene_CR41602.bed annotation/dm3/ensembl_rrna.ucsc.gff.bed annotation/dm3/ensembl_snorna.ucsc.gff.bed annotation/dm3/ensembl_snrna.ucsc.gff.bed annotation/dm3/ensembl_ncrna.ucsc.gff.bed annotation/dm3/ensembl_trna.ucsc.gff.bed annotation/dm3/ensGene_3utr.bed annotation/dm3/ensGene_5utr.bed annotation/dm3/ensGene_codex.bed annotation/dm3/ensGene_introns.bed | \
cut -f 1-6 | \
bedtools sort -i - | \
bedtools merge -s -nms -n -i - | \
perl -ane '$F[5] =~ tr/+-/-+/; print join("\t", @F), "\n"' > annotation_antisense.bed
cat test/test_dm3.bed | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files annotation/dm3/dm3_refGene_whole_gene_rox1.bed annotation/dm3/dm3_refGene_whole_gene_rox2.bed annotation/dm3/dm3_refGene_whole_gene_CR41602.bed annotation/dm3/ensembl_rrna.ucsc.gff.bed annotation/dm3/ensembl_snorna.ucsc.gff.bed annotation/dm3/ensembl_snrna.ucsc.gff.bed annotation/dm3/ensembl_ncrna.ucsc.gff.bed annotation/dm3/ensembl_trna.ucsc.gff.bed annotation/dm3/ensGene_3utr.bed annotation/dm3/ensGene_5utr.bed annotation/dm3/ensGene_codex.bed annotation/dm3/ensGene_introns.bed annotation_antisense.bed \
-names roX1 roX2 CR41602 rRNA snoRNA snRNA ncRNA tRNA 3UTR 5UTR exon intron antisense | gzip > test/test_dm3.genomic_targets.bed_annot.gz
zcat test/test_dm3.genomic_targets.bed_annot.gz | bin/countAnnot.pl | bin/colAdd.sh test/test_dm3 > test/test_dm3.genomic_targets.csv
R --slave --args test/test_dm3.genomic_targets.csv test/test_dm3.genomic_targets roX1 roX2 CR41602 rRNA snoRNA snRNA ncRNA tRNA 3UTR 5UTR exon intron antisense intergenic < bin/plotGenomicTargets.R && touch test/test_dm3.genomic_targets
```

### calls mm10

```
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/ensGene77.type_rRNA.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/ensGene77.type_rRNA.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/mm10_tRNAgenes.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/mm10_tRNAgenes.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/ensGene77.type_snoRNA.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/ensGene77.type_snoRNA.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/ensGene77.type_snRNA.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/ensGene77.type_snRNA.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/ensGene77.type_lincRNA.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/ensGene77.type_lincRNA.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/ensGene77.type_misc_ncRNA.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/ensGene77.type_misc_ncRNA.ucsc.gff.bed
awk 'BEGIN { FS="\t"; OFS="\t"} { print $1, $4-1, $5, $3, $6, $7 }' < annotation/mm10/ensGene77.type_pseudogene.ucsc.gff | sort -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n > annotation/mm10/ensGene77.type_pseudogene.ucsc.gff.bed
cat annotation/mm10/ensGene77.type_rRNA.ucsc.gff.bed annotation/mm10/mm10_tRNAgenes.ucsc.gff.bed annotation/mm10/ensGene77.type_snoRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_snRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_lincRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_misc_ncRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_pseudogene.ucsc.gff.bed annotation/mm10/mm10_ensGene_3utr.bed annotation/mm10/mm10_ensGene_5utr.bed annotation/mm10/mm10_ensGene_codex.bed annotation/mm10/mm10_ensGene_introns.bed | \
cut -f 1-6 | \
bedtools sort -i - | \
bedtools merge -s -nms -n -i - | \
perl -ane '$F[5] =~ tr/+-/-+/; print join("\t", @F), "\n"' > annotation_antisense.bed
cat test/test_mm10.bed | cut -f 1-6 | \
bedtools annotate -counts -s \
-i - \
-files annotation/mm10/ensGene77.type_rRNA.ucsc.gff.bed annotation/mm10/mm10_tRNAgenes.ucsc.gff.bed annotation/mm10/ensGene77.type_snoRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_snRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_lincRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_misc_ncRNA.ucsc.gff.bed annotation/mm10/ensGene77.type_pseudogene.ucsc.gff.bed annotation/mm10/mm10_ensGene_3utr.bed annotation/mm10/mm10_ensGene_5utr.bed annotation/mm10/mm10_ensGene_codex.bed annotation/mm10/mm10_ensGene_introns.bed annotation_antisense.bed \
-names rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene 3UTR 5UTR exon intron antisense | gzip > test/test_mm10.genomic_targets.bed_annot.gz
zcat test/test_mm10.genomic_targets.bed_annot.gz | bin/countAnnot.pl | bin/colAdd.sh test/test_mm10 > test/test_mm10.genomic_targets.csv
R --slave --args test/test_mm10.genomic_targets.csv test/test_mm10.genomic_targets rRNA tRNA snoRNA snRNA lincRNA misc_ncRNA pseudogene 3UTR 5UTR exon intron antisense intergenic < bin/plotGenomicTargets.R && touch test/test_mm10.genomic_targets
```

###

test calls

`targetdist/count_hg19.sh targetdist/test/test_hg19.bed targetdist/test_hg19_fromotherdir`
`targetdist/count_dm3.sh targetdist/test/test_dm3.bed targetdist/test_dm3_fromotherdir`
`targetdist/count_mm10.sh targetdist/test/test_mm10.bed targetdist/test_mm10_fromotherdir`
