package App::Controller::SoftwareSetting;
use Mojo::Base 'App::Controller';

sub show {	
  my $self = shift;
}

sub get_proxysql {
  my $self = shift;
}

sub post_proxysql {
  my $self = shift;
  my $validation = $self->validation;
  
	# host validation
	$validation->required('host')->like(qr/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/);
	unless ( $validation->is_valid('host') ){
		$validation->error( host => ['invalid_host_address'] );
	};
	# port validation
	$validation->required('port')->like(qr/^[0-9]{1,4}$/);
	unless ( $validation->is_valid('port') ){
		$validation->error( port => ['invalid_port'] );
	};
	# username validation
	$validation->required('username')->size(1, 50);
}
1;