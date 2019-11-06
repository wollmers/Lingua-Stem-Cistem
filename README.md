# NAME

Lingua::Stem::Cistem - CISTEM Stemmer for German

<div>
    <a href="https://opensource.org/licenses/Artistic-2.0"><img src="https://img.shields.io/badge/License-Perl-0298c3.svg" alt="Perl"></a>
    <a href="https://travis-ci.org/wollmers/Lingua-Stem-Cistem"><img src="https://travis-ci.org/wollmers/Lingua-Stem-Cistem.png" alt="Build"></a>
    <a href='https://coveralls.io/r/wollmers/Lingua-Stem-Cistem?branch=master'><img src='https://coveralls.io/repos/wollmers/Lingua-Stem-Cistem/badge.png?branch=master' alt='Coverage Status' /></a>
    <a href='http://cpants.cpanauthors.org/dist/Lingua-Stem-Cistem'><img src='http://cpants.cpanauthors.org/dist/Lingua-Stem-Cistem.png' alt='Kwalitee Score' /></a>
    <a href="http://badge.fury.io/pl/Lingua-Stem-Cistem"><img src="https://badge.fury.io/pl/Lingua-Stem-Cistem.svg" alt="CPAN version" height="18"></a>
    <a href="https://kritika.io/users/wollmers/repos/wollmers+Lingua-Stem-Cistem/"><img alt="Kritika grade for Lingua-Stem-Cistem" src="https://kritika.io/users/wollmers/repos/wollmers+Lingua-Stem-Cistem/heads/master/status.svg"></a>
</div>

# SYNOPSIS

    use Lingua::Stem::Cistem;
    my $stemmed_word = Lingua::Stem::Cistem::stem($word);
    my @segments     = Lingua::Stem::Cistem::segment($word);

    use Lingua::Stem::Cistem qw(:orig);
    my $stemmed_word = stem($word);
    my @segments     = segment($word);

    use Lingua::Stem::Cistem qw(:robust);
    my $stemmed_word = stem_robust($word);
    my @segments     = segment_robust($word);

# DESCRIPTION

This is the CISTEM stemmer for German based on the ["OFFICIAL IMPLEMENTATION"](#official-implementation).

Typically stemmers are used in applications like Information Retrieval,
Keyword Extraction or Topic Matching.

It applies the CISTEM stemming algorithm to a word, returning the stem of this word.

Now (2019) CISTEM has the best f-score compared to other stemmers for German on CPAN, while
being one of the fastest.

The methods in this package keep their original logic and API, only the module name
changed from Cistem to Lingua::Stem::Cistem.

Changes in this distribution applied to the ["OFFICIAL IMPLEMENTATION"](#official-implementation):

- packaged for and released on CPAN
- use strict, use warnings
- the method ["stem"](#stem) is 6-9 % faster, ["segment"](#segment) keeps the speed
- undefined parameter word defaults to the empty string ''
- provides two additional methods ["stem\_robust"](#stem_robust) and ["segment\_robust"](#segment_robust) with the same logic as the official ones,
but more robust against low quality input. ["stem\_robust"](#stem_robust) is ~45% and ["segment\_robust"](#segment_robust) ~70 slower.
- Since Version 0.02 the methods ["stem\_robust"](#stem_robust) and ["segment\_robust"](#segment_robust) support a third parameter $keep\_ge\_prefix.
Default is is the previous behavior, i.e. remove the prefix 'ge'.

# OFFICIAL IMPLEMENTATION

It is based on the paper

    Leonie Wei�weiler, Alexander Fraser (2017).
    Developing a Stemmer for German Based on a Comparative Analysis of Publicly Available Stemmers.
    In Proceedings of the German Society for Computational Linguistics and Language Technology (GSCL)

which can be read here:

[http://www.cis.lmu.de/~weissweiler/cistem/](http://www.cis.lmu.de/~weissweiler/cistem/)

In the paper, the authors conducted an analysis of publicly available stemmers, developed
two gold standards for German stemming and evaluated the stemmers based on the
two gold standards. They then proposed the stemmer implemented here and show
that it achieves slightly better f-measure than the other stemmers and is
thrice as fast as the Snowball stemmer for German while being about as fast as
most other stemmers.

Source repository [https://github.com/LeonieWeissweiler/CISTEM](https://github.com/LeonieWeissweiler/CISTEM)

# METHODS

Lingua::Stem::Cistem exports no subroutines per default to avoid conflicts with other stemmers.

You can either use the methods without importing the subroutines

    use Lingua::Stem::Cistem;
    my $stem = Lingua::Stem::Cistem::stem($word);

or import some or all of the methods:

    use Lingua::Stem::Cistem qw(stem segment);
    my $stem = stem($word);
    my @segments = segment($word);

    use Lingua::Stem::Cistem qw(:all);
    my $stem = stem($word);

Supported:

    :all    - imports stem segment stem_robust segment_robust
    :orig   - imports stem segment
    :robust - imports              stem_robust segment_robust

- stem

        stem($word, $case_insensitivity)

    This method takes the word to be stemmed and a boolean specifiying if case-insensitive
    stemming should be used and returns the stemmed word. If only the word
    is passed to the method or the second parameter is 0, normal case-sensitive stemming is used,
    if the second parameter is 1, case-insensitive stemming is used.

    Case sensitivity improves performance only if words in the text may be incorrectly upper case.
    For all-lowercase and correctly cased text, best performance is achieved by
    using the case-sensitive version.

- stem\_robust

        stem_robust($word, $case_insensitivity, $keep_ge_prefix)

    This method works like ["stem"](#stem) with the following differences for robustness:

    - German Umlauts in decomposed normalization form (NFD) work like composed (NFC) ones.
    - Other characters plus combining characters are treated as graphemes, i.e. with length 1
      instead of 2 or more, which has an influence on the resulting stem.
    - The characters $, %, & keep their value, i.e. they roundtrip.
    - If parameter $keep\_ge\_prefix is set, prefix 'ge' is kept in the stem. Be careful
      if this really improves the results. Mostly removing 'ge' performs better.

    This should not be necessary, if the input is carefully normalized, tokenized, and filtered.

- segment

        segment($word, $case_insensitivity)

    This method works very similarly to stem. The only difference is that in
    addition to returning the stem, it also returns the rest that was removed at
    the end. To be able to return the stem unchanged so the stem and the rest
    can be concatenated to form the original word, all subsitutions that altered
    the stem in any other way than by removing letters at the end were left out.

            my ($stem, $suffix) = segment($word);

- segment\_robust

        segment_robust($word, $case_insensitivity, $keep_ge_prefix)

    This method works exactly like ["stem\_robust"](#stem_robust) and returns a list of prefix, stem and suffix:

            my ($prefix, $stem, $suffix) = segment_robust($word);

# SPEED COMPARISON

Tests were run using the file goldstandard1.txt (317441 words, 3.76 MB), which can be
found here:

[https://github.com/LeonieWeissweiler/CISTEM/blob/master/gold\_standards/goldstandard1.txt](https://github.com/LeonieWeissweiler/CISTEM/blob/master/gold_standards/goldstandard1.txt)

The test iterates over the words in the file. Times measured include the overhead of startup and iteration.

       Platform (only one thread used)

       Intel Core i7-4770HQ Processor
       4 Cores, 8 Threads
       2.20 - 3.40 GHz
       6 MB Cache
       16GB DDR3 RAM

       MacOS Mojave Version 10.14.4
       Perl 5.20.1

    +-------------------------------------------------------------+
    | source: goldstandard1.txt   | words: 317441                 |
    +-------------------------------------------------------------+
    | method         | version    | duration | factor | words/sec |
    |-------------------------------------------------------------|
    | stem           | official   |  2.862s  |  1.00  |  110916   |
    | stem           | this v0.01 |  2.678s  |  0.94  |  118536   |
    | stem_robust    | this v0.01 |  4.111s  |  1.44  |   77217   |
    |                |            |          |        |           |
    | segment        | official   |  2.594s  |  1.00  |  122375   |
    | segment        | this v0.01 |  2.642s  |  1.02  |  120151   |
    | segment_robust | this v0.01 |  4.368s  |  1.68  |   72674   |
    +-------------------------------------------------------------+

# SOURCE REPOSITORY

[http://github.com/wollmers/Lingua-Stem-Cistem](http://github.com/wollmers/Lingua-Stem-Cistem)

# AUTHOR

Helmut Wollmersdorfer <helmut@wollmersdorfer.at>

<div>
    <a href='http://cpants.cpanauthors.org/author/wollmers'><img src='http://cpants.cpanauthors.org/author/wollmers.png' alt='Kwalitee Score' /></a>
</div>

# COPYRIGHT

Copyright 2019 Helmut Wollmersdorfer
Copyright 2017 Leonie Wei�weiler (original version)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Lingua::Stem::Snowball](https://metacpan.org/pod/Lingua::Stem::Snowball), [Lingua::Stem::UniNE](https://metacpan.org/pod/Lingua::Stem::UniNE), [Lingua::Stem](https://metacpan.org/pod/Lingua::Stem), [Lingua::Stem::Patch](https://metacpan.org/pod/Lingua::Stem::Patch)
