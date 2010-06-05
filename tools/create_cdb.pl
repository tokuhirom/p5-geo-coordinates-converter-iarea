use strict;
use warnings;
use Path::Class;
use CDB_File;
use autobox; # lovely
use autobox::Core;
use File::Spec;
use Encode;

my $basedir = shift @ARGV or die "Usage: $0 iareadata*/";

sub ms2degree {
    my $x = shift;
    $x/(60*60*1000)
}

my $areacode2center = CDB_File->new(File::Spec->catfile('share', 'areacode2center.cdb'), "areacode2center.$$") or die $!;
my $areacode2name = CDB_File->new(File::Spec->catfile('share', 'areacode2name.cdb'), "areacode2name.$$") or die $!;
my $meshcode2areacode = CDB_File->new(File::Spec->catfile('share', 'meshcode2areacode.cdb'), "meshcode2areacode.$$") or die $!;

[dir($basedir)->children]->grep(sub {
    $_[0] =~ /\.txt$/
})->map(sub {
    $_[0]->slurp;
})->map(sub {
    my ($areacode_high, $areacode_low, $name, $w, $s, $e, $n, $N, $M, $O, $P, $Q, $R, @mesh) = split /,/, $_[0];

    my $areacode = $areacode_high . $areacode_low;
    $areacode2center->insert($areacode, join(",", ms2degree(($n+$s)/2), ms2degree(($e+$w)/2)));
    $areacode2name->insert($areacode, encode_utf8(decode('cp932', $name)));

    for my $meshcode (@mesh) {
        $meshcode2areacode->insert($meshcode, $areacode);
    }
});

$areacode2center->finish;
$areacode2name->finish;
$meshcode2areacode->finish;

