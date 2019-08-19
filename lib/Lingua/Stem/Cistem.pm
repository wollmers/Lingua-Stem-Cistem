#!/usr/bin/perl
package Lingua::Stem::Cistem;

use strict;
use warnings;

use utf8;

use 5.006;
our $VERSION = '0.01';

sub new {
  my $class = shift;
  # uncoverable condition false
  bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
}

sub stem {
    my $self = shift;
    my $word = shift // '';
    my $case_insensitive = shift;

    my $ucfirst = (ucfirst $word eq $word);

    $word =  lc($word);
    $word =~ tr/äöü/aou/;
    $word =~ s/([aou])\N{U+0308}/$1/g; # remove U+0308 COMBINING DIAERESIS
    $word =~ s/ß/ss/g;

    $word =~ s/^ge(.{4,})/$1/;

    #$word =~ s/sch/\$/g;
    #$word =~ s/ei/\%/g;
    #$word =~ s/ie/\&/g;

    $word =~ s/sch/\N{U+0006}/g; # \N{U+0006} ACK
    $word =~ s/ei/\N{U+0007}/g;  # \N{U+0007} BEL
    $word =~ s/ie/\N{U+0008}/g;  # \N{U+0008} BS

    $word =~ s/(.)\1/$1*/g;

    my @graphemes = $word =~ m/\X/g;
    my $length = scalar @graphemes;
    #my $length = scalar (($word =~ m/\X/g)); # does not work

    #while(length($word)>3) {
    while($length > 3) {
        #if( length($word)>5 && ($word =~ s/e[mr]$// || $word =~ s/nd$//) ) {}
        if( $length>5 && ($word =~ s/e[mr]$// || $word =~ s/nd$//) ) {$length -= 2;}
        elsif( (!($ucfirst) || $case_insensitive) && $word =~ s/t$//) {$length--;}
        elsif( $word =~ s/[esn]$//) {$length--;}
        else { last; }
    }

    $word =~ s/(.)\*/$1$1/g;

    #$word =~ s/\$/sch/g;
    #$word =~ s/\%/ei/g;
    #$word =~ s/\&/ie/g;

    $word =~ s/\N{U+0006}/sch/g; # \N{U+0006} ACK
    $word =~ s/\N{U+0007}/ei/g;  # \N{U+0007} BEL
    $word =~ s/\N{U+0008}/ie/g;  # \N{U+0008} BS

    return $word;
}


sub segment {
    my $self = shift;
    my $word = shift // '';
    my $case_insensitive = shift;

    my $ucfirst = (ucfirst $word eq $word);

    $word =  lc($word);
    $word =~ tr/äöü/aou/;
    $word =~ s/([aou])\N{U+0308}/$1/g; # remove U+0308 COMBINING DIAERESIS
    $word =~ s/ß/ss/g;

    my $prefix = '';
    if ($word =~ s/^ge(.{4,})/$1/) {
      $prefix = 'ge';
    }

    my $original = $word;

    #$word =~ s/sch/\$/g;
    #$word =~ s/ei/\%/g;
    #$word =~ s/ie/\&/g;

    $word =~ s/sch/\N{U+0006}/g; # \N{U+0006} ACK
    $word =~ s/ei/\N{U+0007}/g;  # \N{U+0007} BEL
    $word =~ s/ie/\N{U+0008}/g;  # \N{U+0008} BS


    $word =~ s/(.)\1/$1*/g;

    my @graphemes = $word =~ m/\X/g;
    my $length = scalar @graphemes;
    #my $length = scalar (($word =~ m/\X/g)); # does not work

    my $suffix_length = 0;

    while($length > 3){
        if( $length > 5 && ($word =~ s/(e[mr])$// || $word =~ s/(nd)$//) ) {
            $suffix_length += 2;
            $length -= 2;
        }
        elsif( (!($ucfirst) || $case_insensitive) && $word =~ s/t$//) {
            $suffix_length++;
            $length--;
        }
        elsif( $word =~ s/([esn])$//) {
            $suffix_length++;
            $length--;
        }
        else{ last; }
    }

    $word =~ s/(.)\*/$1$1/g;

    #$word =~ s/\$/sch/g;
    #$word =~ s/\%/ei/g;
    #$word =~ s/\&/ie/g;

    $word =~ s/\N{U+0006}/sch/g; # \N{U+0006} ACK
    $word =~ s/\N{U+0007}/ei/g;  # \N{U+0007} BEL
    $word =~ s/\N{U+0008}/ie/g;  # \N{U+0008} BS

    my $suffix = '';

    if( $suffix_length ) {
        $suffix = substr($original, - $suffix_length);
    }

    return ($prefix, $word, $suffix);
    #return ($word, $suffix);
}

1;
__END__

=pod

=encoding UTF-8

=head1 NAME

CISTEM - Stemmer for German

=begin html

<a href="https://opensource.org/licenses/Artistic-2.0"><img src="https://img.shields.io/badge/License-Perl-0298c3.svg" alt="Perl"></a>
<a href="https://travis-ci.org/wollmers/Lingua-Stem-Cistem"><img src="https://travis-ci.org/wollmers/Lingua-Stem-Cistem.png" alt="Build"></a>
<a href='https://coveralls.io/r/wollmers/Lingua-Stem-Cistem?branch=master'><img src='https://coveralls.io/repos/wollmers/Lingua-Stem-Cistem/badge.png?branch=master' alt='Coverage Status' /></a>
<a href='http://cpants.cpanauthors.org/dist/Lingua-Stem-Cistem'><img src='http://cpants.cpanauthors.org/dist/Lingua-Stem-Cistem.png' alt='Kwalitee Score' /></a>
<a href="http://badge.fury.io/pl/Lingua-Stem-Cistem"><img src="https://badge.fury.io/pl/Lingua-Stem-Cistem.svg" alt="CPAN version" height="18"></a>
<a href="https://kritika.io/users/wollmers/repos/wollmers+Lingua-Stem-Cistem/"><img alt="Kritika grade for Lingua-Stem-Cistem" src="https://kritika.io/users/wollmers/repos/wollmers+Lingua-Stem-Cistem/heads/master/status.svg"></a>

=end html

=head1 SYNOPSIS

    use Cistem;
    my $stemmed_word = Cistem::stem($word);

    or, for segmentation:

    my @segments = Cistem::segment($word);

=head1 DESCRIPTION

This is the official Perl implementation of the CISTEM stemmer.
It is based on the paper
Leonie Weissweiler, Alexander Fraser (2017).
Developing a Stemmer for German Based on a Comparative Analysis of Publicly Available Stemmers.
In Proceedings of the German Society for Computational Linguistics and Language Technology (GSCL)
which can be read here:
http://www.cis.lmu.de/~weissweiler/cistem/

In the paper, we conducted an analysis of publicly available stemmers, developed
two gold standards for German stemming and evaluated the stemmers based on the
two gold standards. We then proposed the stemmer implemented here and show
that it achieves slightly better f-measure than the other stemmers and is
thrice as fast as the Snowball stemmer for German while being about as fast as
most other stemmers.

=head1 METHODS

=over 8

=item stem($word, $case_insensitivity, $ge_remove)

This method takes the word to be stemmed and a boolean specifiying if case-insensitive
stemming should be used and returns the stemmed word. If only the word
is passed to the method or the second parameter is 0, normal case-sensitive stemming is used,
if the second parameter is 1, case-insensitive stemming is used.

Case sensitivity improves performance only if words in the text may be incorrectly upper case.
For all-lowercase and correctly cased text, best performance is achieved by
using the case-sensitive version.

=item segment($word, $case_insensitivity)

This method works very similarly to stem. The only difference is that in
addition to returning the stem, it also returns the rest that was removed at
the end. To be able to return the stem unchanged so the stem and the rest
can be concatenated to form the original word, all subsitutions that altered
the stem in any other way than by removing letters at the end were left out.

=back

=head1 SOURCE REPOSITORY

L<http://github.com/wollmers/Lingua-Stem-Cistem>


=head1 AUTHOR

Helmut Wollmersdorfer E<lt>helmut@wollmersdorfer.atE<gt>

=begin html

<a href='http://cpants.cpanauthors.org/author/wollmers'><img src='http://cpants.cpanauthors.org/author/wollmers.png' alt='Kwalitee Score' /></a>

=end html

=head1 COPYRIGHT

Copyright 2019 Helmut Wollmersdorfer

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
