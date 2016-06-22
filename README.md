# targetdist

Count and plot distribution of regions over hierarchical sets of genomic targets.

## Installation

These scripts require 'bedtools' and R packages "ggplot2" and "gridExtra".

The pre-calculated annotations can be downloaded at http://www.bioinf.uni-freiburg.de/~maticzkd/targetdist_annotation_v0_1.tar.bz2 and have to be extracted in the targetdist base directory.

```
cd targetdist
wget http://www.bioinf.uni-freiburg.de/~maticzkd/targetdist_annotation_v0_1.tar.bz2
tar xf targetdist_annotation_v0_1.tar.bz2
```

## Usage

Targetdist contains three scripts to count hits for pre-calculated annotations for hg19, dm3 and mm10.
The scripts take two positional arguments.
The first positional argument is the filename of the bed coordinates to summarize.
The results will be written to the file supplied as second positional argument.
The input bed files should have at least 6 columns and include strand information.
All fields beyond the 6th column will be ignored.
The pre-calculated annotations use UCSC-like chromosome identifiers.

Example calls:

* `./count_hg19.sh test/test_hg19.bed test_hg19.csv`
* `./count_dm3.sh test/test_hg19.bed test_hg19.csv`
* `./count_mm10.sh test/test_hg19.bed test_hg19.csv`

## Example output

![targetdist example plot](test/example_outputs/test_dm3.png?raw=true "tergetdist example plot")
