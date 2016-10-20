package App::Controller::SoftwareSetting;
use Mojo::Base 'App::Controller';
use Try::Tiny;

sub show {
  my $self = shift;
  $self->stash( 'proxysql_connection' => $self->model('base')->proxysql_connection() );
  $self->stash( 'company' => $self->model('base')->company() );
}

sub get_proxysql {
  my $self = shift;
  $self->stash( 'proxysql_connection' => $self->model('base')->proxysql_connection() );
}

sub update_proxysql {
  my $self = shift;
  my $validation = $self->validation;
  my $proxysql_version;
  
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

  # password validation
  $validation->required('password')->size(1, 50);

  my $data = {  id        => 1,
                host      => $self->param('host'),
                port      => $self->param('port'),
                username  => $self->param('username'),
                password  => $self->param('password')};

  $self->model('SoftwareSetting')->update_proxysql_connection($data);
  $self->stash( 'proxysql_connection' => $self->model('base')->proxysql_connection() );
  
  my $proxysql_connection = $self->model('base')->proxysql_connection();
  my $p = Net::Ping->new();
     $p->port_number($proxysql_connection->{port});

  # Host is aliven
  if( $p->ping($proxysql_connection->{host}, 3 ) ){
    try {
      $proxysql_version = $self->model('base')->proxysql_version();
    }
  }
  $p->close();

  $self->stash( 'proxysql_version' => $proxysql_version );
}
1;