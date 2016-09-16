package App::Model::Admin;

use Mojo::Base -base;
use Mojo::Exception;
use Scalar::Util qw/ blessed /;
use Try::Tiny;

# Create a new admin user
sub create {
  my $self = shift;
	my %opts = @_; # we still need to look at parameters that don't correspond to attributes

	use Data::Dumper;
	print STDERR "OPTS: ",Dumper(\%opts);
	
	return;	
}
1;