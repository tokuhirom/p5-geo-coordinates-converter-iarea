package Geo::Coordinates::Converter::iArea;
use strict;
use warnings;
our $VERSION = '0.07';
use 5.00800;
use Geo::Coordinates::Converter;
use CDB_File;
use File::ShareDir 'dist_file';
Geo::Coordinates::Converter->add_default_formats('iArea');

sub get_center {
    my ($class, $areacode) = @_;

    my $file = dist_file('Geo-Coordinates-Converter-iArea', 'areacode2center.cdb');
    my $cdb = CDB_File->TIEHASH($file);
    if ($cdb->EXISTS($areacode)) {
        my ($lat, $lng) = split /,/, $cdb->FETCH($areacode);
        return Geo::Coordinates::Converter->new(
            lat      => $lat,
            lng      => $lng,
            datum    => 'tokyo',
            format   => 'degree',
            areacode => $areacode,
        );
    } else {
        return;
    }
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

=head1 METHODS

=head2 get_center

get center of area code.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom aaaatttt gmail dotottto commmmmE<gt>

=head1 SEE ALSO

L<Geo::Coordinates::Converter>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
