#! /bin/bash 
[ $# -ne 1 ] && echo "Add a new constant colum separated by a tab." && echo "Usage:  $(basename $0) colstring" && echo "Instead of: $(basename $0) $*"  && exit 1

cat /dev/stdin | awk -v string=$1 '{print $0"\t"string}'
