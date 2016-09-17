package App::Model::Main;
use Mojo::Base -base;

has 'proxy_db';

sub mysql_servers {
  shift->proxy_db->db->query('SELECT * FROM mysql_servers')->hashes;
}

#sub mysql_servers {	
	#my $self = shift;
	#my $db = $self->proxy_db->db;
  #my $results = $db->query('SELECT * FROM mysql_servers;')->hashes;
	#return $results;
#}
1;