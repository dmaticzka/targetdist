GENOME:=hg19
BEDTOOLS:=bedtools
SORT:=sort
R:=R
BEDSORT:=$(SORT) -k1,1V -k2,2n -k3,3n -k6,6 -k4,4 -k5,5n

################################################################################
### genome-specific rules, fixed to hg19 for now
include annotation/$(GENOME)/Makefile_annotation

# statistics genomic targets
BED_GENOMIC_TARGETS=$(SRC_TARGET_DIST:%.bed=%.genomic_targets.bed_annot.gz)
STATS_GENOMIC_TARGETS=$(SRC_TARGET_DIST:%.bed=%.genomic_targets.csv)
# plot genomic targets
FIGS_GENOMIC_TARGETS=$(SRC_TARGET_DIST:%.bed=%.genomic_targets)

# convert gtf to bed
%.bed : %.gtf
	awk 'BEGIN { FS="\t"; OFS="\t"} { print $$1, $$4-1, $$5, $$3, $$6, $$7 }' < $< > $@

# convert chromosome ids
%.ucsc.gff : %.gff
	awk '{print "chr"$$0}' < $< > $@

# convert gff to bed
%.ucsc.gff.bed : %.ucsc.gff
	awk 'BEGIN { FS="\t"; OFS="\t"} { print $$1, $$4-1, $$5, $$3, $$6, $$7 }' < $< | $(BEDSORT) > $@

annotation_antisense.bed : $(ANNOT_BED)
	cat $(ANNOT_BED) | \
	cut -f 1-6 | \
	$(BEDTOOLS) sort -i - | \
	$(BEDTOOLS) merge -s -nms -n -i - | \
	perl -ane '$$F[5] =~ tr/+-/-+/; print join("\t", @F), "\n"' > $@

%.genomic_targets.bed_annot.gz : %.bed $(ANNOT)
	cat $< | cut -f 1-6 | \
	$(BEDTOOLS) annotate -counts -s \
	-i - \
	-files $(ANNOT) \
	-names $(ANNOT_NAMES) | gzip > $@

# count number of overlaps with different types of genomic regions
%.genomic_targets.csv : %.genomic_targets.bed_annot.gz bin/countAnnot.pl bin/colAdd.sh
	zcat $< | bin/countAnnot.pl | bin/colAdd.sh $* > $@

%.genomic_targets : %.genomic_targets.csv bin/plotGenomicTargets.R
	$(R) --slave --args $< $@ $(ANNOT_NAMES) intergenic < bin/plotGenomicTargets.R && touch $@
