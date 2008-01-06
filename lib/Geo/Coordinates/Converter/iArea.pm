package Geo::Coordinates::Converter::iArea;
use strict;
use warnings;
our $VERSION = '0.02';
use File::ShareDir 'dist_file';

sub get_center {
    my ($class, $areacode) = @_;

    my $file = dist_file('Geo-Coordinates-Converter-iArea', 'iarea-center.csv');
    open my $fh, '<', $file or die $!;

    my $geo;
    while (my $line = <$fh>) {
        if (index($line, $areacode) >= 0) {
            my @dat = split m{,}, $line;

            $geo = Geo::Coordinates::Converter->new(
                lat    => $dat[1],
                lng    => $dat[2],
                datum  => 'tokyo',
                format => 'degree'
            );

            last;
        }
    }

    close $fh;
    return $geo;
}

1;
__END__

=for stopwords aaaatttt dotottto gmail DoCoMo MOVA csv FOMA

=head1 NAME

Geo::Coordinates::Converter::iArea - get center point from iArea

=head1 SYNOPSIS

  use Geo::Coordinates::Converter::iArea;
  Geo::Coordinates::Converter::iArea->get_center('00205');
  # => instance of Geo::Coordinates::Converter

=head1 WARNINGS

THIS MODULE IS IN ITS BETA QUALITY. THE API MAY CHANGE IN THE FUTURE.

=head1 DESCRIPTION

Geo::Coordinates::Converter::iArea is utilities for DoCoMo iArea.

easy to get the center point of area.

=head1 DATA FILE FORMAT

    areacode,lat,lng

csv format.

=head1 Note

This module very slow. But, this module is only for small edge case.
This modules is called by very old obsolete DoCoMo phones, called MOVA.

Please use posinfo=1 when user's phone is FOMA.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom aaaatttt gmail dotottto commmmmE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
