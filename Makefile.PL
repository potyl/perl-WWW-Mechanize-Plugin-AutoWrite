use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME              => 'WWW::Mechanize::Plugin::AutoWrite',
	VERSION_FROM      => 'lib/WWW/Mechanize/Plugin/AutoWrite.pm', # finds $VERSION
	PREREQ_PM         => {
		'Test::More'        => 0,
		'WWW::Mechanize'    => 0,
		'File::Slurp'       => 0,
		'Test::Differences' => 0,
		'File::Temp'        => 0,
		'MIME::Types'       => 0,
		'File::Path'        => 0,
		'File::Spec'        => 0,
		'File::Basename'    => 0,
	},
	($] >= 5.005 ?     ## Add these new keywords supported since 5.005
		(
			ABSTRACT_FROM => 'lib/WWW/Mechanize/Plugin/AutoWrite.pm', # retrieve abstract from module
			AUTHOR        => 'Jozef Kutej <jkutej@cpan.org>'
		)
		: ()
	),
	( MM->can('signature_target') ? (SIGN => 1) : () ),
);