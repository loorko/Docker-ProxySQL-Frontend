package App::Model::User;
use Mojo::Base -base;

has 'mysql';

sub mysql_users {
  shift->mysql->db->query('SELECT * FROM mysql_users')->hashes;
}
1;