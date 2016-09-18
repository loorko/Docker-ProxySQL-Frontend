package App::Controller::User;
use Mojo::Base 'App::Controller';

sub list {	
  my $self = shift;

	my $res = App::DB->new()->check_proxysql_connection();
	$self->stash( 'admin_version' => $res );
	unless ( $res ){ $self->redirect_to('/software_setting/proxysql/edit'); return; };
	
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