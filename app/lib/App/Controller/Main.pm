package App::Controller::Main;
use Mojo::Base 'App::Controller';

sub index {
  my $self = shift;
	$self->redirect_to('/main');
}

sub main {	
  my $self = shift;
	$self->stash( 'mysql_servers' => $self->model('main')->mysql_servers() );
}

1;