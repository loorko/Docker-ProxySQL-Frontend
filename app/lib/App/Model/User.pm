package App::Model::User;
use Mojo::Base 'MojoX::Model';

sub mysql_users {
  my $self = shift;
  my $db =  App::DB->new()->proxy_db->db;
  my $results = $db->query('SELECT * FROM mysql_users;')->hashes;
  $db->disconnect;
  return $results;
}
1;