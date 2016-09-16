package App::Model::Main;
use Mojo::Base -base;

has 'mysql';

sub mysql_servers {
  shift->mysql->db->query('SELECT * FROM mysql_servers')->hashes;
}

#sub mysql_servers {	
	#my $self = shift;
	#my $db = $self->mysql->db;
  #my $results = $db->query('SELECT * FROM mysql_servers;')->hashes;
	#return $results;
#}
1;