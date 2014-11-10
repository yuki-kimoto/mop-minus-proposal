use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'mop::minus',
    VERSION_FROM      => 'lib/mop/minus.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {
      'Object::Simple' => '3.12',
      'Parse::Keyword' => '0.08'
    }, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/mop/minus.pm', # retrieve abstract from module
    AUTHOR            => 'Yuki Kimoto<kimoto.yuki@gmail.com>',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
