package App::Controller::Base;
use Mojo::Base 'App::Controller';
use Try::Tiny;

sub check_proxysql_connection {
  my $self = shift;
  my $proxysql_version;

  $self->stash( 'company'       => $self->model('base')->company() );
  $self->stash( 'menu'          => $self->model('base')->menu() );

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

  unless ( $proxysql_version ){
    if( $self->match->endpoint->name ne 'software_settingproxysqledit' ){
      $self->redirect_to('/software_setting/proxysql/edit');
      return 0;
    };
  };
  return 1;
}
1;