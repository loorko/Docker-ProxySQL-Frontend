package App::Model::SoftwareSetting;
use Mojo::Base -base;

has 'app_db';

sub update_proxysql_connection {
  my ($self, $data) = @_;	
  my $sql = 'UPDATE proxysql_connection SET host = ?, port = ?, user = ?, pass = ? WHERE id = ?';
	my $db = $self->app_db->db;
	$db->query($sql, $data->{host}, $data->{port}, $data->{username}, $data->{password}, $data->{id});
	$db->disconnect;
}
1;