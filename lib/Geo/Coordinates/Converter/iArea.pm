package Geo::Coordinates::Converter::iArea;
use strict;
use warnings;
our $VERSION = '0.03';
use Geo::Coordinates::Converter;
use Geo::Coordinates::Converter::iArea::DataLoader;
Geo::Coordinates::Converter->add_default_formats('iArea');

sub get_center {
    my ($class, $areacode) = @_;

    Geo::Coordinates::Converter::iArea::DataLoader->first(
        sub {
            my $dat = shift;
            if ($dat->{areacode} eq $areacode) {
                return Geo::Coordinates::Converter->new(
                    lat      => $dat->{center_lat},
                    lng      => $dat->{center_lng},
                    datum    => 'tokyo',
                    format   => 'degree',
                    areacode => $areacode
                );
            }
        }
    ) || undef;
}

1;
__END__

=for stopwords aaaatttt dotottto gmail DoCoMo MOVA csv FOMA API

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
