use strict;
use warnings;
use Path::Class;
use autobox; # lovely
use autobox::Core;

my $basedir = shift @ARGV or die "Usage: $0 iareadata*/";

sub SCALAR::say { print $_[0], "\n" }

sub ms2degree {
    my $x = shift;
    $x/(60*60*1000)
}

[dir($basedir)->children]->grep(sub {
    $_[0] =~ /\.txt$/
})->map(sub {
    $_[0]->slurp;
})->map(sub {
    my ($areacode_high, $areacode_low, $name, $w, $s, $e, $n) = split /,/, $_[0];
    my $areacode = $areacode_high . $areacode_low;
    [$areacode, ms2degree(($n+$s)/2), ms2degree(($e+$w)/2)]->join(",");
})->join("\n")->say;

