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

  my $proxy_db = Mojo::mysql->new();
  $proxy_db->dsn("dbi:mysql:host=$host;port=$port");
  $proxy_db->username($user);
  $proxy_db->password($pass);
  return $proxy_db;
}
1;