use strict;
use warnings;
use Path::Class;
use CDB_File;
use autobox; # lovely
use autobox::Core;
use File::Spec;

my $basedir = shift @ARGV or die "Usage: $0 iareadata*/";

sub ms2degree {
    my $x = shift;
    $x/(60*60*1000)
}

my $area2center = CDB_File->new(File::Spec->catfile('share', 'area2center.cdb'), "area2center.$$") or die $!;
my $meshcode2areacode = CDB_File->new(File::Spec->catfile('share', 'meshcode2areacode.cdb'), "meshcode2areacode.$$") or die $!;

[dir($basedir)->children]->grep(sub {
    $_[0] =~ /\.txt$/
})->map(sub {
    $_[0]->slurp;
})->map(sub {
    my ($areacode_high, $areacode_low, $name, $w, $s, $e, $n, $N, $M, $O, $P, $Q, $R, @mesh) = split /,/, $_[0];

    my $areacode = $areacode_high . $areacode_low;
    $area2center->insert($areacode, join(",", ms2degree(($n+$s)/2), ms2degree(($e+$w)/2)));

    for my $meshcode (@mesh) {
        $meshcode2areacode->insert($meshcode, $areacode);
    }
});

$area2center->finish;
$meshcode2areacode->finish;

