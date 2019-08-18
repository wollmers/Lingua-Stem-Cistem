sub segment{
    $word = shift;
    $case\_insensitive = shift;
    $rest\_length = 0;

    $upper = (ucfirst $word eq $word);

    $word = lc($word);

    $original = $word;

    $word =~s/sch/\$/g;
    $word =~s/ei/\%/g;
    $word =~s/ie/\&/g;

    $word =~ s/(.)\1/\1\*/g;

# NAME

CISTEM - Stemmer for German

<div>
    <a href="https://travis-ci.org/wollmers/Lingua-Stem-Cistem"><img src="https://travis-ci.org/wollmers/Lingua-Stem-Cistem.png" alt="Lingua-Stem-Cistem"></a>
    <a href='https://coveralls.io/r/wollmers/Lingua-Stem-Cistem?branch=master'><img src='https://coveralls.io/repos/wollmers/Lingua-Stem-Cistem/badge.png?branch=master' alt='Coverage Status' /></a>
    <a href='http://cpants.cpanauthors.org/dist/Lingua-Stem-Cistem'><img src='http://cpants.cpanauthors.org/dist/Lingua-Stem-Cistem.png' alt='Kwalitee Score' /></a>
    <a href="http://badge.fury.io/pl/Lingua-Stem-Cistem"><img src="https://badge.fury.io/pl/Lingua-Stem-Cistem.svg" alt="CPAN version" height="18"></a>
    <a href="https://kritika.io/users/davorg/repos/wollmers+Lingua-Stem-Cistem/"><img alt="Kritika grade for Lingua-Stem-Cistem" src="https://kritika.io/users/wollmers/repos/wollmers+Lingua-Stem-Cistem/heads/master/status.svg"></a>
    =end html

    # SYNOPSIS

        use Cistem;
        my $stemmed_word = Cistem::stem($word);

        or, for segmentation:

        my @segments = Cistem::segment($word);


    # DESCRIPTION

    This is the official Perl implementation of the CISTEM stemmer.
    It is based on the paper
    Leonie Wei�weiler, Alexander Fraser (2017).
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

    # METHODS

    - stem($word, $case_insensitivity)

        This method takes the word to be stemmed and a boolean specifiying if case-insensitive
        stemming should be used and returns the stemmed word. If only the word
        is passed to the method or the second parameter is 0, normal case-sensitive stemming is used,
        if the second parameter is 1, case-insensitive stemming is used.

        Case sensitivity improves performance only if words in the text may be incorrectly upper case.
        For all-lowercase and correctly cased text, best performance is achieved by
        using the case-sensitive version.

    - segment($word, $case_insensitivity)

        This method works very similarly to stem. The only difference is that in
        addition to returning the stem, it also returns the rest that was removed at
        the end. To be able to return the stem unchanged so the stem and the rest
        can be concatenated to form the original word, all subsitutions that altered
        the stem in any other way than by removing letters at the end were left out.

    # SOURCE REPOSITORY

    L<http://github.com/wollmers/Lingua-Stem-Cistem>

    # AUTHOR

    Helmut Wollmersdorfer E<lt>helmut.wollmersdorfer@gmail.comE<gt>

    <div>
            <a href='http://cpants.cpanauthors.org/author/wollmers'><img src='http://cpants.cpanauthors.org/author/wollmers.png' alt='Kwalitee Score' /></a>
    </div>

    # COPYRIGHT

    Copyright 2019 Helmut Wollmersdorfer

    # LICENSE

    This library is free software; you can redistribute it and/or modify
    it under the same terms as Perl itself.

    # SEE ALSO
</div>

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 86:

    You forgot a '=back' before '=head1'