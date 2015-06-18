# README FOR THE `Pod-Spelling` DISTRIBUTION

This package contains a number of modules for spell-checking POD
using either `Text::Hunspell`, `Lingua::Ispell` or `Text::Aspell`,
in that order. One of those modules must be installed on your system, 
along with their binaries, unless you plan to use the API to provide
your own spell-checker.

## INSTALLATION

Install a spelling module, one of:

    cpanm Text::Hunspell
    cpanm Lingua::Ispell
    cpanm Text::Aspell

Install this module:

    cpanm Pod::Spelling

Or download, extract, and run:

	perl Makefile.PL
	make
	make test
	sudo make install

# Copyright and License

Copyright (C) Lee Goddard 2009-2015, ff. All Rights Reserved.

Made available under the same terms as the Perl language.
