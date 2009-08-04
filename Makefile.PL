use inc::Module::Install;
name 'Geo-Coordinates-Converter-iArea';
all_from 'lib/Geo/Coordinates/Converter/iArea.pm';

requires 'File::ShareDir' => 1.00;
requires 'Geo::Coordinates::Converter' => 0.04;
requires 'CDB_File' => 0.96;

author_tests('xt');
install_share 'share';
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
