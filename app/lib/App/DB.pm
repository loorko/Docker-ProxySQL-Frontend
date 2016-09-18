package App::DB;

use Mojo::Base -base;
use Mojo::mysql;
use Mojo::SQLite;
use Net::Ping;
use Try::Tiny;

sub new { bless {}, shift }

sub app_db {
  my $self = shift;
  return Mojo::SQLite->new("sqlite:app.db");
}

sub proxy_db {
  my $self = shift;
  my $proxysql_connection = app_db->db->query('SELECT * FROM proxysql_connection')->hash;
  my $host = $proxysql_connection->{host};
  my $port = $proxysql_connection->{port};
  my $user = $proxysql_connection->{user};
  my $pass = $proxysql_connection->{pass};
  #use Data::Dumper;
  #say Dumper($proxysql_connection);
  my $proxy_db = Mojo::mysql->new();
  $proxy_db->dsn("dbi:mysql:host=$host;port=$port");
  $proxy_db->username($user);
  $proxy_db->password($pass);
  return $proxy_db;
}

sub check_proxysql_connection {
  my $self = shift;
  my $admin_version = undef;

  my $proxysql_connection = app_db->db->query('SELECT * FROM proxysql_connection')->hash;
  my $p = Net::Ping->new();
     $p->port_number($proxysql_connection->{port});
    
  # Host is aliven
  if( $p->ping($proxysql_connection->{host}, 3 ) ){
    try {
      my $db = proxy_db->db;
      $admin_version = $db->query('SELECT variable_value FROM global_variables WHERE variable_name = "admin-version"')->hash->{variable_value};
      $db->disconnect;
    }
  }
  $p->close();
  
  return $admin_version;
}
1;