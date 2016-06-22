#!/usr/bin/env perl
use feature ':5.10';
use strict 'vars';
use warnings;
use Getopt::Long;
use Pod::Usage;
use List::Util qw/ min max /;
use POSIX qw/ceil floor/;
use File::Temp qw(tempdir);
use File::Basename;

=head1 NAME

=head1 SYNOPSIS

Options:

#    -id         id used for first columns of output (will be split by '_')
    -debug      enable debug output
    -help       brief help message
    -man        full documentation

=head1 DESCRIPTION

=cut

###############################################################################
# parse command line options
###############################################################################
my $first_column;
my $help;
my $man;
my $debug;
my $result = GetOptions (
#							"id=s"  => \$first_column,
                            "help"	=> \$help,
							"man"	=> \$man,
							"debug" => \$debug);
pod2usage(-exitstatus => 1, -verbose => 1) if $help;
pod2usage(-exitstatus => 0, -verbose => 2) if $man;
($result) or pod2usage(2);

# report position of first non zero element
sub getCount {
  # check all array elements for non zero value
  for(my $pos=0; $pos< scalar @_; $pos++) {
    # return position of non zero value
    if ($_[$pos] != 0) {
      return $pos;
    }
  }

  # if all elements are zero, return extra position for "not_annotated"
  return scalar @_;
}

###############################################################################
# main
###############################################################################

my @counts;

# parse header, add "not_annotated"
# first five! fields are bed6
my $header = <>;
chomp $header;
my (undef,undef,undef,undef,undef,@header) = split("\t", $header);
push @header, "not_annotated";
$debug and say STDERR join("§", @header);

# parse count fields, starting from 7th
while (<>) {
	chomp $_;
	my (undef,undef,undef,undef,undef,undef, @fields) = split("\t", $_);
	$debug and say STDERR  join("§", @fields);
	$counts[getCount(@fields)]++;
}

# generate output
$debug and say STDERR join("§", @counts);
#(scalar @header == scalar @counts) or die("error: header and counts don't match. " . scalar @header . "!=" . scalar @counts);
foreach my $id (@header) {
  my $count = shift @counts;
  if (not defined $count) {
    $count = 0;
  }
  say join("\t", $id, $count);
}
# say join("\t", @header);
# say join("\t", @counts);
