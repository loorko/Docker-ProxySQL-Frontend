package App::Model::SoftwareSetting;
use Mojo::Base -base;

sub update_proxysql_connection {
  my ($self, $data) = @_;
  my $db =  App::DB->new()->app_db->db;
  my $sql = 'UPDATE proxysql_connection SET host = ?, port = ?, user = ?, pass = ? WHERE id = ?';
	$db->query($sql, $data->{host}, $data->{port}, $data->{username}, $data->{password}, $data->{id});
	$db->disconnect;
}
1;