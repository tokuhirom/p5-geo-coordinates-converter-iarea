use strict;
use warnings;
use CDB_File;

my $file = shift @ARGV or die "Usage: $0";

tie my %data, 'CDB_File', $file
  or die "$0: can't tie to $file: $!\n";
while ( my ( $k, $v ) = each %data ) {
    print '+', length $k, ',', length $v, ":$k->$v\n";
}
print "\n";
