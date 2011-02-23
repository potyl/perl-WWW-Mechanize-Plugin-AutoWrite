package WWW::Mechanize::Plugin::AutoWrite;

=head1 NAME

WWW::Mechanize::Plugin::AutoWrite - WWW::Mechanize plugin to automaticaly write fetched page content to a file

=head1 SYNOPSIS

	use WWW::Mechanize;
	use WWW::Mechanize::Plugin::AutoWrite;
	
	$mech = WWW::Mechanize->new();
	$mech->autowrite('/tmp/mech.html');
	
	$mech->get('http://www.cpan.org');		#now the $mech->content of the get is automaticali stored to /tmp/mech.html

=head1 DESCRIPTION

WWW::Mechanize::Plugin::AutoWrite overrides WWW::Mechanize::get method and every time the $mech->get() is called
it stores $mech->content() to a file set by $mech->autowrite() method.

You can then use epiphany browser to see this file. When ever epiphany detects that the content
of the file changed it will reload it. So if you have a double screen you can execute code on
one screen and watch the page is changing on the other automaticaly.

=cut


use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use File::Slurp qw{ write_file };

my $original_www_mechanize_get;

BEGIN {
	 $original_www_mechanize_get = \&WWW::Mechanize::get;
}


sub WWW::Mechanize::autowrite {
	my $self = shift;

	# set
	if (@_) {
		$self->{'autowrite_filename'} = shift;
	}
	# get
	else {
		return $self->{'autowrite_filename'};
	}
}


no warnings qw{ redefine };

sub WWW::Mechanize::get {
	my $self = shift;

	my $get_return = $original_www_mechanize_get->($self, @_);

	my $autowrite_filename = $self->{'autowrite_filename'};
	if (defined $autowrite_filename) {
		write_file($autowrite_filename, $self->content);
	}
	
	return $get_return;
}


1;


=head1 SEE ALSO

L<http://search.cpan.org/perldoc?WWW::Mechanize::Plugin::Display>

=head1 AUTHOR

Jozef Kutej, E<lt>jk@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Jozef Kutej

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
