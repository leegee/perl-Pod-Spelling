# README FOR THE `Pod-Spelling` DISTRIBUTION

This package contains a number of modules for spell-checking POD
using either `Lingua::Ispell` or `Text::Aspell`. One of those modules
must be installed on your system, with their binaries, unless you
plan to use the API to provide your own spell-checker.

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
