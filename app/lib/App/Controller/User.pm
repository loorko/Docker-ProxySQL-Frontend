package App::Controller::User;
use Mojo::Base 'App::Controller';

sub list {
  my $self = shift;
  $self->stash( 'mysql_users' => $self->model('user')->mysql_users() );
}

sub form {
  my $self = shift;
}

sub create {
  my $self = shift;

  my $validation = $self->validation;
  $validation->required('username')->size(1, 30);
}
1;