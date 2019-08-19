#!perl

use strict;
use warnings;

use utf8;

binmode(STDOUT,":encoding(UTF-8)");
binmode(STDERR,":encoding(UTF-8)");

use lib qw(../lib/);

use Test::More;
use Test::More::UTF8;

use Lingua::Stem::Cistem;

my $cistem = Lingua::Stem::Cistem->new();

my $examples0 = [
  [ qw(inhaltsleerer inhaltsleer) ],
  [ qw(Hast has) ],
  [ qw(Geangeheiratetem angeheirat) ],
  [ qw(Leheröööör leheroooor) ],
  [ qw(geheilwässert heilwass) ],
  [ qw(heißwässert heißwass) ],
  [ qw(Geborcherndt borcherndt) ],

];

my $tests = [
# format: [ in, out, casing, ge-remove ]
[ 'transliterate', [
  #[,''], # TODO
  ['ABC','abc'],
  ['ÄÖÜ','aou'],
  ['äöü','aou'],
  ['ß','ss'],
  ['ßß','ssss'],

  ['sch','sch'],
  ['ei','ei'],
  ['ie','ie'],
  ['aa','aa'],

]],

#[ 'unwordy', [
#  ['$','sch'],
#  ['%','ei'],
#  ['&','ie'],
#]],

[ 'wordy', [
  ['$','$'],
  ['%','%'],
  ['&','&'],

]],

[ 'prefix', [
  ['ge123','ge123'],
  ['ge1234','1234'],

]],

[ 'suffix', [
  ['123em','123em'],
  ['1234em','1234'],

  ['123er','123er'],
  ['1234er','1234'],

  ['123nd','123nd'],
  ['1234nd','1234'],

  ['12e','12e'],
  ['123e','123'],

  ['12s','12s'],
  ['123s','123'],

  ['12n','12n'],
  ['123n','123'],

]],

[ 'suffix_t', [
  ['12t','12t'],
  ['123t','123t'],
  ['123t','123t',0],
  ['123t','123',1],

  ['Hut','hut'],
  ['Hut','hut',0],
  ['Hut','hut',1],

  ['Hast','hast'],
  ['Hast','hast',0],
  ['Hast','has',1],

  ['hat','hat'],
  ['hat','hat',0],
  ['hat','hat',1],

  ['hast','has'],
  ['hast','has',0],
  ['hast','has',1],

]],


# U+0308 COMBINING DIAERESIS
# \N{COMBINING DIARESIS}
# U+00EB LATIN SMALL LETTER E WITH DIAERESIS
[ 'unicode', [

  ["a\N{U+0308}",'a'],

  ["\N{U+00EB}","\N{U+00EB}"],
  ["e\N{U+0308}","e\N{U+0308}"],
  ["Citro\N{U+00EB}n","citro\N{U+00EB}"],
  ["Citroe\N{U+0308}n","citroe\N{U+0308}"],

]],
];

#################################

if (0) {
  for my $test_group (@{$tests}) {
    my $test_name = $test_group->[0];
    my $group_tests = $test_group->[1];
      for my $test (@{$group_tests}) {
        my ($word,$expect,$casing,$ge_remove) =
          @{$test};
        my $casing_string = (defined $casing) ? "$casing" : '';
        my $ge_remove_string = (defined $ge_remove) ? $casing : '';
        is($cistem->stem($word,$casing,$ge_remove),$expect
          ,
          $test_name
          . ' '
          . 'stem('
          . $word
          . ','
          . $casing_string
          . ','
          . $ge_remove_string
          . ') => '
          . $expect
        );
      }
  }
}

if (1) {
  for my $test_group (@{$tests}) {
    my $test_name = $test_group->[0];
    my $group_tests = $test_group->[1];
      for my $test (@{$group_tests}) {
        my ($word,$expect,$casing,$ge_remove) =
          @{$test};
        my $casing_string = (defined $casing) ? "$casing" : '';
        my $ge_remove_string = (defined $ge_remove) ? $casing : '';
        is([$cistem->segment($word,$casing,$ge_remove)]->[1],$expect
          ,
          $test_name
          . ' '
          . 'segment('
          . $word
          . ','
          . $casing_string
          . ','
          . $ge_remove_string
          . ') => '
          . $expect
        );
      }
  }
}


if (0) {
  for my $example (@$examples0) {
    is($cistem->stem($example->[0]),$example->[1],"$example->[0] -> $example->[1]");
  }
}

=pod

for my $word (@words) {
  for my $case_sensitive (0..1) {
    print 'Cistem::stem(',$word,',',$case_sensitive,'): ',
    Cistem::stem($word,$case_sensitive),"\n";
  }

  for my $case_sensitive (0..1) {
    print 'Cistem::segment(',$word,',',$case_sensitive,'): ',
    join('-',Cistem::segment($word,$case_sensitive)),"\n";
  }
}

=cut

done_testing;
