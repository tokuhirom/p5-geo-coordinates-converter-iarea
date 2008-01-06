package Geo::Coordinates::Converter::Format::IArea;
use strict;
use warnings;
use base 'Geo::Coordinates::Converter::Format';
our $VERSION = '0.01';
use Geo::Coordinates::Converter::iArea::DataLoader;

sub name { 'iarea' }

sub detect {
    my($self, $point) = @_;
    return unless _get_center( $point->areacode );
    return $self->name;
}

# other(e.g. wgs84) to iarea
sub from {
    my ($self, $point) = @_;

    my @mesh = _calc_meshcode($point);

    # I know this code is slow... please tune up this code :)
    my $mesh_re = join("|", @mesh);
    my $re = qr{^(?:$mesh_re)$};
    my $areacode = Geo::Coordinates::Converter::iArea::DataLoader->first(
        sub {
            my $dat = shift;

            for my $mesh (@{$dat->{meshcodes}}) {
                if ($mesh =~ $re) {
                    return $dat->{areacode};
                }
            }
        }
    );

    $point->areacode($areacode);
    $point;
}

sub _calc_meshcode {
    my $point = shift;

    # normalize
    $point = do {
        my $geo = Geo::Coordinates::Converter->new(point => $point);
        $geo->convert('degree', 'tokyo');
    };

    my ($lat,$lng) = map { int ($_ * 60 * 60 * 1000) } ($point->lat, $point->lng);

    my $mesh;
    my @mesh;
    my $ab = int($lat / 2400000);
    my $cd = int($lng / 3600000) - 100;
    my $x1 = ($cd +100) * 3600000;
    my $y1 = $ab * 2400000;
    my $e = int(($lat - $y1) / 300000);
    my $f = int(($lng - $x1) / 450000);
    $mesh = $ab.$cd.$e.$f;
    push @mesh, $mesh;

    my $x2 = $x1 + $f * 450000;
    my $y2 = $y1 + $e * 300000;
    my $l3 = int(($lng - $x2) / 225000);
    my $m3 = int(($lat - $y2) / 150000);
    my $g = $l3 + $m3 * 2;
    $mesh .= $g;
    push @mesh, $mesh;

    my $x3 = $x2 + $l3 * 225000;
    my $y3 = $y2 + $m3 * 150000;
    my $l4 = int(($lng - $x3) / 112500);
    my $m4 = int(($lat - $y3) / 75000);
    my $h = $l4 + $m4 * 2;
    $mesh .= $h;
    push @mesh, $mesh;

    my $x4 = $x3 + $l4 * 112500;
    my $y4 = $y3 + $m4 * 75000;
    my $l5 = int(($lng - $x4) / 56250);
    my $m5 = int(($lat - $y4) / 37500);
    my $i = $l5 + $m5 * 2;
    $mesh .= $i;
    push @mesh, $mesh;

    my $x5 = $x4 + $l5 * 56250;
    my $y5 = $y4 + $m5 * 37500;
    my $l6 = int(($lng - $x5) / 28125);
    my $m6 = int(($lat - $y5) / 18750);
    my $j = $l6 + $m6 * 2;
    $mesh .= $j;
    push @mesh, $mesh;

    my $x6 = $x5 + $l6 * 28125;
    my $y6 = $y5 + $m6 * 18750;
    my $l7 = int(($lng - $x6) / 14062.5);
    my $m7 = int(($lat - $y6) / 9375);
    my $k = $l7 + $m7 * 2;
    $mesh .= $k;
    push @mesh, $mesh;

    @mesh;
}

# iarea to other(e.g. wgs84)
sub to {
    my($self, $point) = @_;
    my $area_geo = _get_center($point->areacode ) || { lat => '0.000000', lng => '0.000000' };

    $point->lat($area_geo->{lat});
    $point->lng($area_geo->{lng});
    $point->datum('tokyo');

    $point;
}

sub _get_center {
    my $areacode = shift;

    Geo::Coordinates::Converter::iArea::DataLoader->first(
        sub {
            my $dat = shift;

            if ($dat->{areacode} eq $areacode) {
                return +{
                    lat => $dat->{center_lat},
                    lng => $dat->{center_lng},
                };
            }
        }
    );
}

Geo::Coordinates::Converter::Point->mk_accessors(qw/ areacode /);
sub Geo::Coordinates::Converter::areacode {
    my $self = shift;
    my $point = shift || $self->current;
    $point->areacode;
}

1;
__END__

=for stopwords aaaatttt dotottto gmail DoCoMo MOVA csv FOMA kazuhiro osawa areacode

=head1 NAME

Geo::Coordinates::Converter::Format::IArea - get center point from iArea

=head1 SYNOPSIS

  use Geo::Coordinates::Converter;

  my $geo = Geo::Coordinates::Converter->new( formats => [qw/ iArea /], format => 'iarea', areacode => '00205' )
  my $point = $geo->convert('degree' => 'wgs84');

  Geo::Coordinates::Converter->add_default_formats('iArea');
  my $geo = Geo::Coordinates::Converter->new(  format => 'iarea', areacode => '00205' )
  my $point = $geo->convert('degree' => 'wgs84');

=head1 DESCRIPTION

Geo::Coordinates::Converter::Format::IArea is utilities for DoCoMo iArea.

easy to get the center point of area.

=head1 EXPORT METHODS

=over 4

=item Geo::Coordinates::Converter->areacode

areacode accessor

=item Geo::Coordinates::Converter::Point->areacode

areacode accessor

=back

=head1 DATA FILE FORMAT

    areacode,lat,lng

csv format.

=head1 Note

This module very slow. But, this module is only for small edge case.
This modules is called by very old obsolete DoCoMo phones, called MOVA.

Please use posinfo=1 when user's phone is FOMA.

=head1 AUTHOR

Kazuhiro Osawa

=head1 SEE ALSO

C<Geo::Coordinates::Converter::iArea>, L<Location::Area::DoCoMo::iArea>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
