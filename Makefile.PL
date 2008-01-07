use inc::Module::Install;
name 'Geo-Coordinates-Converter-iArea';
all_from 'lib/Geo/Coordinates/Converter/iArea.pm';

requires $_ for (qw/
    File::ShareDir
    Geo::Coordinates::Converter
/);

install_share 'share';
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
