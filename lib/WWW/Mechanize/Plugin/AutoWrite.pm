package WWW::Mechanize::Plugin::AutoWrite;

=head1 NAME

WWW::Mechanize::Plugin::AutoWrite - WWW::Mechanize plugin to automaticaly write fetched page content to a file

=head1 SYNOPSIS

	use WWW::Mechanize;
	use WWW::Mechanize::Plugin::AutoWrite;
	
	$mech = WWW::Mechanize->new();
	$mech->autowrite('/tmp/mech.html');
	
	$mech->get('http://search.cpan.org');
	#now the $mech->content of the GET is automaticaly stored to /tmp/mech.html

	$mech->submit_form(
		'form_name' => 'f',
		'fields'    => {
			'query' => 'WWW::Mechanize::Plugin::AutoWrite',
			'mode'  => 'module', 
		},
	);
	#now the $mech->content of the POST result is automaticaly stored to /tmp/mech.html

=head1 DESCRIPTION

WWW::Mechanize::Plugin::AutoWrite overrides WWW::Mechanize::request method
and every time the $mech->get or ->submit, ->submit_form, etc. is called
it stores $mech->content() to a filename set by $mech->autowrite() method.

You can then use epiphany browser to see this file. When ever epiphany detects that the content
of the file changed it will reload it. So if you have a double screen you can execute code on
one screen and watch the page is changing on the other automaticaly.

=cut


use 5.006;
use strict;
use warnings;

our $VERSION = '0.02';

use File::Slurp qw{ write_file };

my $original_www_mechanize_request;

BEGIN {
	 $original_www_mechanize_request = \&WWW::Mechanize::request;
}


sub _write_to_file {
	my $mech = shift;

	#write to file if defined
	my $autowrite_filename = $mech->{'autowrite'};

	if (defined $autowrite_filename) {
		write_file($autowrite_filename, $mech->content);
	}
}


sub WWW::Mechanize::autowrite {
	my $self = shift;

	# set
	if (@_) {
		$self->{'autowrite'} = shift;
	}
	# get
	else {
		return $self->{'autowrite'};
	}
}


no warnings qw{ redefine };

sub WWW::Mechanize::request {
	my $self = shift;
	
	my $return = $original_www_mechanize_request->($self, @_);

	_write_to_file($self);
	
	return $return;
}


1;


=head1 SEE ALSO

L<http://search.cpan.org/perldoc?WWW::Mechanize::Plugin::Display>

=head1 AUTHOR

Jozef Kutej, E<lt>jozef@kutej.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Jozef Kutej

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
