# targetdist

Plot distribution over hierarchical sets of genomic targets.

## Usage

This contains three scripts to count hits for prepared annotations for hg19, dm3 and mm10.
The scripts take two positional arguments.
The first positional argument is the filename of the bed coordinates to summarize.
The results will be written to the file suppliead as second positional argument.
The input bed files should have at least 6 columns and include strand information.
All fields beyond the 6th column will be ignored.
Chromosomes should be given as UCSC identifiers.

Example calls:

* `./count_hg19.sh test/test_hg19.bed test_hg19.csv`
* `./count_dm3.sh test/test_hg19.bed test_hg19.csv`
* `./count_mm10.sh test/test_hg19.bed test_hg19.csv`
