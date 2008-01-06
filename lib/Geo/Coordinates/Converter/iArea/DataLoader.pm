package Geo::Coordinates::Converter::iArea::DataLoader;
use strict;
use warnings;
use File::ShareDir 'dist_file';

sub first {
    my ($class, $code, ) = @_;

    my $file = dist_file('Geo-Coordinates-Converter-iArea', 'iarea.csv');
    open my $fh, '<', $file or die $!;

    my $ret;
    while (my $line = <$fh>) {
        my %dat;
        my @row = split /,/, $line;
        $dat{areacode} = $row[0] . $row[1];
        $dat{areaname} = $row[2];
        $dat{center_lng} = ($row[3]+$row[5])/2/(60*60*1000); # tokyo, degree
        $dat{center_lat} = ($row[4]+$row[6])/2/(60*60*1000);
        $dat{meshcodes} = [@row[13..@row-1]];

        $ret = $code->(\%dat);
        if ($ret) {
            last;
        }
    }

    close $file;
    return $ret;
}

1;
__END__

=head1 NAME

Geo::Coordinates::Converter::iArea::DataLoader - i-area data loader

=head1 SYNOPSIS

    use Geo::Coordinates::Converter::iArea::DataLoader;
    Geo::Coordinates::Converter::iArea::DataLoader->first(sub {
        my $area_data = shift;
        if ($area_data->{areacode} eq '00101') {
            return 1; # break loop when callback return true value.
        } else {
            return 0;
        }
    });

=head1 DESCRIPTION

This is i-area data loader.

THIS MODULE IS INTERNAL MODULE.

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<Geo::Coordinates::Converter::iArea>, L<Geo::Coordinates::Converter>

