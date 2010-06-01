use inc::Module::Install;
name 'Geo-Coordinates-Converter-iArea';
all_from 'lib/Geo/Coordinates/Converter/iArea.pm';

requires 'CDB_File' => 0.96;
requires 'Geo::Coordinates::Converter' => 0.04;
requires 'Flie::ShareDir' => 1.02;

install_share 'share';
build_requires 'Test::More';
build_requires 'ExtUtils::MakeMaker' => 6.42;
use_test_base;
auto_include;
WriteAll;
