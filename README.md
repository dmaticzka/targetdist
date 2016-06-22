# targetdist

Targetdist counts the number of peaks, crosslinking events or other intervals overlapping various classes of genomic targets, such as ncRNAs, UTRs, introns and exons. Should a peak overlap multiple annotations it is attributed to the annotation with highest priority. Priority of target classes descends from left to right.

## Installation

The targetdist scripts require _perl_, _bedtools_ and R packages _ggplot2_ and _gridExtra_.

The pre-calculated annotations can be downloaded from http://www.bioinf.uni-freiburg.de/~maticzkd/targetdist_annotation_v0_1.tar.bz2 and should be be extracted in the targetdist base directory as shown below.

```
cd targetdist
wget http://www.bioinf.uni-freiburg.de/~maticzkd/targetdist_annotation_v0_1.tar.bz2
tar xf targetdist_annotation_v0_1.tar.bz2
```

## Usage

Targetdist contains three scripts to count hits for pre-calculated annotations for hg19, dm3 and mm10.
The scripts take two positional arguments.
The first positional argument is the filename of the bed coordinates to summarize.
Results will be written to the files prefixed with the second positional argument.
Currently this are the calculated table of hits (.csv) and two summary plots (.png, .pdf).
The input bed should have at least 6 columns and include strand information.
All fields beyond the 6th column will be ignored.
The pre-calculated annotations use UCSC-like chromosome identifiers.

Example calls:

* `./targetdist_hg19.sh test/test_hg19.bed test_hg19.csv`
* `./targetdist_dm3.sh test/test_hg19.bed test_hg19.csv`
* `./targetdist_mm10.sh test/test_hg19.bed test_hg19.csv`

## Example plots

### hg19
![targetdist example hg19](test/example_outputs/test_hg19.png?raw=true "targetdist example hg19")

### dm3
![targetdist example dm3](test/example_outputs/test_dm3.png?raw=true "targetdist example dm3")

### mm10
![targetdist example mm10](test/example_outputs/test_mm10.png?raw=true "targetdist example mm10")
