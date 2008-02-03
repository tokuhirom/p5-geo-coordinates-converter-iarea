use strict;
use warnings;
use Benchmark;
use Geo::Coordinates::Converter;
use Geo::Coordinates::Converter::Format::IArea;
use Geo::Coordinates::Converter::iArea;

timethese(
    10000 => +{
        'area2center first' => sub {
            Geo::Coordinates::Converter::iArea->get_center('00100');
        },
        'area2center last' => sub {
            Geo::Coordinates::Converter::iArea->get_center('25100');
        },
        'area2center fail' => sub {
            Geo::Coordinates::Converter::iArea->get_center('99999');
        },

        'pos2areacode' => sub {
            my $geo = Geo::Coordinates::Converter->new(
                lat   => '35.65580',
                lng   => '139.65580',
                datum => 'wgs84'
            );
            $geo->format('iarea');
        },
      }
);

