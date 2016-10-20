package App::Controller::Main;
use Mojo::Base 'App::Controller';

sub index {
  my $self = shift;
  $self->redirect_to('/main');
}

sub main {
  my $self = shift;
  my $mysql_servers;
  $mysql_servers = $self->model('main')->mysql_servers();
  $self->stash( 'mysql_servers' => $mysql_servers );
}

1;