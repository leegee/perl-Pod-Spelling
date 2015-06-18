use strict;
use warnings;

package Pod::Spelling::Hunspell;

use base 'Pod::Spelling';
no warnings 'redefine';

use Carp;
require Text::Hunspell;

our $VERSION = 0.1;


# The default dictionary depends on the locale settings. The following
# environment variables are searched: 
#
#		LC_ALL, LC_MESSAGES, and LANG. 
#
# If none are set then the following fallbacks are used:
#
# /usr/share/myspell/default.aff Path of default affix file. See hunspell(4).
# /usr/share/myspell/default.dic Path of default dictionary file. See hunspell(4).
# $HOME/.hunspell_default. Default path to personal dictionary.

our $CONFIG_ROOT_PATH;

sub _guess_paths {
	my @langs;
	my $CONFIG_ROOT_PATH;

	my @paths = qw(
		/usr/share/hunspell/
		/usr/local/bin/myspell
		/usr/local/sbin/myspell
		/usr/bin/myspell
		/opt/usr/bin/myspell
		/opt/local/bin/myspell
	);


	foreach my $i (qw( LC_ALL LC_MESSAGES LANG )){
		next unless $ENV{$i};
		push @langs, $ENV{$i};
		my ($gen) = $ENV{$i} =~ /([^.]+)\.[^.]+$/;
		push @langs, $gen if $gen;
	}

	@langs = (qw( en_GB en_US )) if not @langs;

	my @full_paths;

	foreach my $path (@paths){
		foreach my $lang (@langs){
			push @full_paths, $path .'/'.$lang;
		}
	}

	push @full_paths, 
		'/usr/share/myspell/default',
		'/usr/share/hunspell/default',
		($ENV{HOME}? $ENV{HOME}.'/.hunspell_default' : ()),
		($ENV{HOME}? $ENV{HOME}.'/.myspell_default' : ());

	foreach my $path (@full_paths){
		next if not -e $path .'.dic';
		next if not -e $path .'.aff';
		$CONFIG_ROOT_PATH = $path;
		last;
	}

	return $CONFIG_ROOT_PATH;
}

sub _init {
	shift if not ref $_[0];
	my $self = shift || {};

	if (not defined $self->{hunspell_aff} and not defined $self->{hunspell_dic} ){
		$CONFIG_ROOT_PATH = _guess_paths() if not $CONFIG_ROOT_PATH;
		confess 'No hunspell_aff and hunspell_dic, and could not even guess at paths' if not $CONFIG_ROOT_PATH;
		if (-e $CONFIG_ROOT_PATH .'.aff' and -e $CONFIG_ROOT_PATH .'.dic'){
			$self->{hunspell_aff} = $CONFIG_ROOT_PATH.'.aff';
			$self->{hunspell_dic} = $CONFIG_ROOT_PATH.'.dic';
		} 
		else {
			confess 'Guessed path root was useless, ', $CONFIG_ROOT_PATH, '*';
		}

		$self->{hunspell} = Text::Hunspell->new( $self->{hunspell_aff}, $self->{hunspell_dic} );
		if (not $self->{hunspell}->check('house')){
			confess "Hunspell could not spell 'house',\n",
				"\tusing aff ",$self->{hunspell_aff},"\n",
				"\tusing dic ",$self->{hunspell_dic};
		} 
	}

	# if (not defined $self->{hunspell_aff} or not defined $self->{hunspell_dic}){
	# 	$self->{spell_check_callback} = undef;	
	# }

	return $self;
}


# Accepts one or more lines of text, returns a list mispelt words.
sub _spell_check_callback {
	my ($self, @lines) = @_;
	my $errors;

	for my $word ( split /\s+/, join( ' ', @lines ) ){
		next if not $word;
		if (not $self->{hunspell}->check($word)){
			warn 'ERROR '.$word;
			$errors->{ $word } ++;
		}
	}
	
	return keys %$errors;
}

1;

__END__

=head1 NAME

Pod::Spelling::Hunspell - Spell-test POD with hunspell

=head1 SYNOPSIS

	my $o = Pod::Spelling::Hunspell->new(
		allow_words => qw[ Django Rheinhardt ],
	);
	warn "Spelling errors: ", join ', ', $o->check_file( 'blib/Paris.pm' );

=head1 DESCRIPTION

Checks the spelling in POD using the C<hunspell> program, which is expected
to be found on the system. 

When calling the constructor, you may supply the arguments C<hunspell_dic>
and C<hunspell_aff> to specify the full paths to the C<hunspell> dictionaries. 
Otherwise, this module will have a guess, but may have missed possible locations.

For details of options and methods, see the parent class,
L<Pod::Spelling|Pod::Spelling>.

=head1 SEE ALSO

L<Pod::Spelling>, L<Test::Pod::Spelling>.

=head1 AUTHOR

Lee Goddard (C<lgoddard-at-cpan.org>)

=head1 LICENCE AND COPYRIGHT

Copyright (C) 2011, Lee Goddard. All Rights Reserved.

Made available under the same terms as Perl.



