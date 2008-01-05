use strict;
use warnings;
use Test::More tests => 7;
use Geo::Coordinates::Converter;
use Geo::Coordinates::Converter::iArea;

# 200 area ok
sub {
    my $geo = Geo::Coordinates::Converter::iArea->get_center('05905');
    isa_ok $geo, 'Geo::Coordinates::Converter';

    my $point = $geo->convert('degree', 'wgs84');
    isa_ok $point, 'Geo::Coordinates::Converter::Point';
    is $point->lat, '35.645168';
    is $point->lng, '139.723348';
    is $point->datum, 'wgs84';
    is $point->format, 'degree';
}->();

# 404 area not found
sub {
    my $geo2 = Geo::Coordinates::Converter::iArea->get_center('99999');
    is $geo2, undef;
}->();

