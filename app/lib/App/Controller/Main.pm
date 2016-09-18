package App::Controller::Main;
use Mojo::Base 'App::Controller';

sub index {
  my $self = shift;
  $self->redirect_to('/main');
}

sub main {
  my $self = shift;

  my $res = App::DB->new()->check_proxysql_connection();
  $self->stash( 'admin_version' => $res );
  unless ( $res ){ $self->redirect_to('/software_setting/proxysql/edit'); return; };

  $self->stash( 'mysql_servers' => $self->model('main')->mysql_servers() );
}

1;