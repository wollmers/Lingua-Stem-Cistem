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

is($cistem->stem(),'',"undef -> empty string");
is($cistem->stem('ABC'),'abc',"ABC -> abc");
is($cistem->stem('ÄÖÜ'),'aou',"ÄÖÜ -> aou");
is($cistem->stem('äöü'),'aou',"äöü -> aou");
is($cistem->stem('ß'),'ss',"ß -> ss");

is($cistem->stem('sch'),'sch',"sch -> sch");
is($cistem->stem('ei'),'ei',"ei -> ei");
is($cistem->stem('ie'),'ie',"ie -> ie");
is($cistem->stem('aa'),'aa',"aa -> aa");

is($cistem->stem('ge123'),'ge123',"ge123 -> ge123");
is($cistem->stem('ge1234'),'1234',"ge1234 -> 1234");

is($cistem->stem('123em'),'123em',"123em -> 123em");
is($cistem->stem('1234em'),'1234',"1234em -> 1234");

is($cistem->stem('123er'),'123er',"123er -> 123er");
is($cistem->stem('1234er'),'1234',"1234er -> 1234");

is($cistem->stem('123nd'),'123nd',"123nd -> 123nd");
is($cistem->stem('1234nd'),'1234',"1234nd -> 1234");

is($cistem->stem('12e'),'12e',"12e -> 12e");
is($cistem->stem('123e'),'123',"123e -> 123");

is($cistem->stem('12s'),'12s',"12s -> 12s");
is($cistem->stem('123s'),'123',"123s -> 123");

is($cistem->stem('12n'),'12n',"12n -> 12n");
is($cistem->stem('123n'),'123',"123n -> 123");

is($cistem->stem('12t'),'12t',"12t -> 12t");
is($cistem->stem('123t'),'123t',"123t -> 123t");
is($cistem->stem('123t',0),'123t',"123t,0 -> 123t");
is($cistem->stem('123t',1),'123',"123t,1 -> 123");

is($cistem->stem('Hut'),'hut',"Hut -> hut");
is($cistem->stem('Hut',0),'hut',"Hut,0 -> hut");
is($cistem->stem('Hut',1),'hut',"Hut,1 -> hut");

is($cistem->stem('Hast'),'hast',"Hast -> hast");
is($cistem->stem('Hast',0),'hast',"Hast,0 -> hast");
is($cistem->stem('Hast',1),'has',"Hast,1 -> has");

is($cistem->stem('hat'),'hat',"hat -> hat");
is($cistem->stem('hat',0),'hat',"hat,0 -> hat");
is($cistem->stem('hat',1),'hat',"hat,1 -> hat");

is($cistem->stem('hast'),'has',"hast -> has");
is($cistem->stem('hast',0),'has',"hast,0 -> has");
is($cistem->stem('hast',1),'has',"hast,1 -> has");

# U+0308 COMBINING DIAERESIS
# \N{COMBINING DIARESIS}
is($cistem->stem("a\N{U+0308}"),'a',"a,diaresis -> a");

# U+00EB LATIN SMALL LETTER E WITH DIAERESIS
is($cistem->stem("\N{U+00EB}"),"\N{U+00EB}","e-diaresis -> e-diaresis");
is($cistem->stem("e\N{U+0308}"),"e\N{U+0308}","e,diaresis -> e,diaresis");
is($cistem->stem("Citro\N{U+00EB}n"),"citro\N{U+00EB}","Citro\N{U+00EB}n -> citro\N{U+00EB}");
is($cistem->stem("Citroe\N{U+0308}n"),"citroe\N{U+0308}","Citroe\N{U+0308}n -> citroe\N{U+0308}");

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
