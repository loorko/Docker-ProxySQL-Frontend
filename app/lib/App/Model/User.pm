package App::Model::User;
use Mojo::Base -base;

has 'proxy_db';

sub mysql_users {
  shift->proxy_db->db->query('SELECT * FROM mysql_users')->hashes;
}
1;