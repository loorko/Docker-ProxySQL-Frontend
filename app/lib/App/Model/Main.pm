package App::Model::Main;
use Mojo::Base -base;

sub mysql_servers {	
  my $self = shift;
  my $db =  App::DB->new()->proxy_db->db;
  my $results = $db->query('SELECT * FROM mysql_servers;')->hashes;
  $db->disconnect;
  return $results;
}
1;