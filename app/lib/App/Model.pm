package App::Model;

use Mojo::Base -base;
use Mojo::Loader qw(find_modules load_class);
use Carp qw/ croak /;
use Try::Tiny;

has modules => sub { {} };

sub new {
  my $class = shift;
  my %args = @_;
  my $self = $class->SUPER::new(@_);

  for my $module (find_modules 'App::Model') {
    my $e = load_class $module;
    warn qq{Loading "$module" failed: $e} and next if ref $e;
    my ($basename) = $module =~ /.*::(.*)/;
    $self->modules->{lc $basename} = $module->new(%args);
  }
  return $self;
}

# Get a model object by name
sub model {
  my ($self, $model) = @_;
  return $self->{modules}{$model} || croak "Unknown model `$model'";
}
1;