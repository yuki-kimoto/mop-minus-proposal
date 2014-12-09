use ExtUtils::MakeMaker;
use strict;
use warnings;

my %WriteMakefileArgs = (
    NAME              => 'mop::minus',
    VERSION_FROM      => 'lib/mop/minus.pm',
    PREREQ_PM         => {
      'Parse::Keyword' => '0.08',
      'true' => '0.18'
    },
    ABSTRACT_FROM     => 'lib/mop/minus.pm', # retrieve abstract from module
    AUTHOR            => 'Yuki Kimoto<kimoto.yuki@gmail.com>',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    OBJECT            => '$(O_FILES)', # link all the C files too
);

use Devel::CallParser 'callparser1_h', 'callparser_linkable';
use File::Spec::Functions 'abs2rel';
{
    open my $fh, '>', 'callparser1.h' or die $!;
    print { $fh } callparser1_h or die $!;
    close $fh or die $!;
}
my @linkable = map { abs2rel($_) } callparser_linkable;
unshift @linkable, '$(BASEEXT)$(OBJ_EXT)' if @linkable;
$WriteMakefileArgs{OBJECT} = join(' ', @linkable) if @linkable;
$WriteMakefileArgs{clean}{FILES} .= ' callparser1.h';

WriteMakefile(%WriteMakefileArgs);
