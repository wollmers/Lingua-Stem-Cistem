#!/usr/bin/perl
package Lingua::Stem::Cistem;

use strict;
use warnings;

use utf8;

sub stem {
    my $word = shift // '';
    my $case_insensitive = shift;

    my $upper = (ucfirst $word eq $word);

    $word =  lc($word);
    $word =~ tr/äöü/aou/;
    $word =~ s/ß/ss/g;

    $word =~ s/^ge(.{4,})/$1/;

    $word =~ s/sch/\$/g;
    $word =~ s/ei/\%/g;
    $word =~ s/ie/\&/g;
    $word =~ s/(.)\1/$1*/g;

    while(length($word)>3) {
        if( length($word)>5 && ($word =~ s/e[mr]$// || $word =~ s/nd$//) ) {}
        elsif( (!($upper) || $case_insensitive) && $word =~ s/t$//) {}
        elsif( $word =~ s/[esn]$//) {}
        else { last; }
    }

    $word =~ s/(.)\*/$1$1/g;
    $word =~ s/\$/sch/g;
    $word =~ s/\%/ei/g;
    $word =~ s/\&/ie/g;

    return $word;
}

=pod

sub segment{
    $word = shift;
    $case_insensitive = shift;
    $rest_length = 0;

    $upper = (ucfirst $word eq $word);

    $word = lc($word);

    $original = $word;

    $word =~s/sch/\$/g;
    $word =~s/ei/\%/g;
    $word =~s/ie/\&/g;

    $word =~ s/(.)\1/\1\*/g;

=cut

sub segment {
    my $word = shift // '';
    my $case_insensitive = shift;

    my $upper = (ucfirst $word eq $word);

    $word =  lc($word);
    #$word =~ tr/äöü/aou/;
    #$word =~ s/ß/ss/g; # this changes the length

    #my $prefix = '';
    #if ($word =~ s/^ge(.{4,})/$1/) {
    #  $prefix = 'ge';
    #}

    my $original = $word;

    $word =~ s/sch/\$/g;
    $word =~ s/ei/\%/g;
    $word =~ s/ie/\&/g;
    $word =~ s/(.)\1/$1*/g;

    my $suffix_length = 0;

    while(length($word)>3){
        if( length($word)>5 && ($word =~ s/(e[mr])$// || $word =~ s/(nd)$//) ) {
            $suffix_length += 2;
        }
        elsif( (!($upper) || $case_insensitive) && $word =~ s/t$//) {
            $suffix_length++;
        }
        elsif( $word =~ s/([esn])$//) {
            $suffix_length++;
        }
        else{ last; }
    }

    $word =~ s/(.)\*/$1$1/g;

    $word =~ s/\$/sch/g;
    $word =~ s/\%/ei/g;
    $word =~ s/\&/ie/g;

    my $suffix = '';

    if( $suffix_length ) {
        $suffix = substr($original, - $suffix_length);
    }

    #return ($prefix, $word, $suffix);
    return ($word, $suffix);
}

1;
__END__

=encoding utf-8

=pod

=head1 NAME

CISTEM Stemmer for German

=head1 SYNOPSIS

    use Cistem;
    my $stemmed_word = Cistem::stem($word);

    or, for segmentation:

    my @segments = Cistem::segment($word);

=head1 DESCRIPTION

This is the official Perl implementation of the CISTEM stemmer.
It is based on the paper
Leonie Weißweiler, Alexander Fraser (2017).
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

=item stem($word, $case_insensitivity)

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

=cut
