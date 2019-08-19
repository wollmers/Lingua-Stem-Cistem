package Lingua::Stem::Cistem;

use strict;
use warnings;

use utf8;

use 5.006;

require Exporter;

BEGIN {
    $Lingua::Stem::Cistem::VERSION     = '0.01';
    @Lingua::Stem::Cistem::ISA         = qw(Exporter);
    @Lingua::Stem::Cistem::EXPORT      = qw();
    @Lingua::Stem::Cistem::EXPORT_OK   = qw(stem segment stem_robust segment_robust);
    %Lingua::Stem::Cistem::EXPORT_TAGS = (
        'all'            => [qw(stem segment stem_robust segment_robust)],
        'orig'           => [qw(stem segment)],
        'robust'         => [qw(stem_robust segment_robust)],
    );
}

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

sub segment {
    my $word = shift // '';
    my $case_insensitive = shift;

    my $upper = (ucfirst $word eq $word);

    $word =  lc($word);
    #$word =~ tr/äöü/aou/;
    #$word =~ s/ß/ss/g; # this changes the length

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

sub stem_robust {
    my $word = shift // '';
    my $case_insensitive = shift;

    my $ucfirst = (ucfirst $word eq $word);

    $word =  lc($word);
    $word =~ tr/äöü/aou/;
    $word =~ s/([aou])\N{U+0308}/$1/g; # remove U+0308 COMBINING DIAERESIS
    $word =~ s/ß/ss/g;

    $word =~ s/^ge(.{4,})/$1/;

    $word =~ s/sch/\N{U+0006}/g; # \N{U+0006} ACK
    $word =~ s/ei/\N{U+0007}/g;  # \N{U+0007} BEL
    $word =~ s/ie/\N{U+0008}/g;  # \N{U+0008} BS

    $word =~ s/(.)\1/$1*/g;

    my @graphemes = $word =~ m/\X/g;
    my $length = scalar @graphemes;
    #my $length = scalar (($word =~ m/\X/g)); # does not work

    while($length > 3) {
        if( $length>5 && ($word =~ s/e[mr]$// || $word =~ s/nd$//) ) {$length -= 2;}
        elsif( (!($ucfirst) || $case_insensitive) && $word =~ s/t$//) {$length--;}
        elsif( $word =~ s/[esn]$//) {$length--;}
        else { last; }
    }

    $word =~ s/(.)\*/$1$1/g;

    $word =~ s/\N{U+0006}/sch/g; # \N{U+0006} ACK
    $word =~ s/\N{U+0007}/ei/g;  # \N{U+0007} BEL
    $word =~ s/\N{U+0008}/ie/g;  # \N{U+0008} BS

    return $word;
}


sub segment_robust {
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

    $word =~ s/sch/\N{U+0006}/g; # \N{U+0006} ACK
    $word =~ s/ei/\N{U+0007}/g;  # \N{U+0007} BEL
    $word =~ s/ie/\N{U+0008}/g;  # \N{U+0008} BS

    $word =~ s/(.)\1/$1*/g;

    my @graphemes = $word =~ m/\X/g;
    my $length = scalar @graphemes;

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

    $word =~ s/\N{U+0006}/sch/g; # \N{U+0006} ACK
    $word =~ s/\N{U+0007}/ei/g;  # \N{U+0007} BEL
    $word =~ s/\N{U+0008}/ie/g;  # \N{U+0008} BS

    my $suffix = '';

    if( $suffix_length ) {
        $suffix = substr($original, - $suffix_length);
    }

    return ($prefix, $word, $suffix);
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

    use Lingua::Stem::Cistem;
    my $stemmed_word = Lingua::Stem::Cistem::stem($word);
    my @segments     = Lingua::Stem::Cistem::segment($word);

    use Lingua::Stem::Cistem qw(:orig);
    my $stemmed_word = stem($word);
    my @segments     = segment($word);

    use Lingua::Stem::Cistem qw(:robust);
    my $stemmed_word = stem_robust($word);
    my @segments     = segment_robust($word);

=head1 DESCRIPTION

This is the CISTEM stemmer for German based on the L</OFFICIAL IMPLEMENTATION>.

It targets at typical tasks like Information Retrieval, Keyword Extraction or Topic Matching.

Now (2019) CISTEM has the best f-score compared to other stemmers for German on CPAN, while
being one of the fastest.

This distribution is adapted to CPAN standards, and the method L</stem> is 6-9 % faster. It also
provides the two methods L</stem_robust> and L</segment_robust> with the same logic as the official ones,
but more robust against low quality input, but 40-70 % slower.

=head1 OFFICIAL IMPLEMENTATION

It is based on the paper

Leonie Weissweiler, Alexander Fraser (2017).
Developing a Stemmer for German Based on a Comparative Analysis of Publicly Available Stemmers.
In Proceedings of the German Society for Computational Linguistics and Language Technology (GSCL)

which can be read here:

L<http://www.cis.lmu.de/~weissweiler/cistem/>

In the paper, the authors conducted an analysis of publicly available stemmers, developed
two gold standards for German stemming and evaluated the stemmers based on the
two gold standards. They then proposed the stemmer implemented here and show
that it achieves slightly better f-measure than the other stemmers and is
thrice as fast as the Snowball stemmer for German while being about as fast as
most other stemmers.

Source repository L<https://github.com/LeonieWeissweiler/CISTEM>

=head1 METHODS

=over 8

=item stem

    stem($word, $case_insensitivity)

This method takes the word to be stemmed and a boolean specifiying if case-insensitive
stemming should be used and returns the stemmed word. If only the word
is passed to the method or the second parameter is 0, normal case-sensitive stemming is used,
if the second parameter is 1, case-insensitive stemming is used.

Case sensitivity improves performance only if words in the text may be incorrectly upper case.
For all-lowercase and correctly cased text, best performance is achieved by
using the case-sensitive version.

=item stem_robust

    stem_robust($word, $case_insensitivity)

This method works like L</stem> with the following differences for robustness:

- German Umlauts in decomposed normalization form (NFD) work like composed (NFC) ones.
- Other characters plus combining characters as treated as graphemes, i.e. with length 1
  instead of 2 or more, which has an influence on the resulting stem.
- The characters $, %, & keep their value, i.e. they roundtrip.

This should not be necessary, if the input is carefully normalized, tokenized, and filtered.

=item segment

    segment($word, $case_insensitivity)

This method works very similarly to stem. The only difference is that in
addition to returning the stem, it also returns the rest that was removed at
the end. To be able to return the stem unchanged so the stem and the rest
can be concatenated to form the original word, all subsitutions that altered
the stem in any other way than by removing letters at the end were left out.

	my ($stem, $suffix) = segment($word);

=item segment_robust

    segment_robust($word, $case_insensitivity)

This method works exactly like L<stem_robust> and returns a list of prefix, stem and suffix:

	my ($prefix, $stem, $suffix) = segment_robust($word);

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

L<Lingua::Stem::Snowball>, L<Lingua::Stem::UniNE>, L<Lingua::Stem>, L<Lingua::Stem::Patch>

=cut
