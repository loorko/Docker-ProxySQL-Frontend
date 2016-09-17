package App::Model::Base;
use Mojo::Base -base;

sub menu {
  my $self = shift;
  my $menu;

	$menu = [ {	'name'		=> 'Dashboard',
							'action'	=> '/main',
							'icon'		=> 'dashboard'},
					 {	'name'		=> 'Users',
							'action'	=> '/users',
							'icon'		=> 'users'}];
	
  return $menu;
}

sub proxysql_connection {
	my $self = shift;
	my $db =  App::DB->new()->app_db->db;
  my $result = $db->query('SELECT * FROM proxysql_connection')->hash;
  $db->disconnect;
  return $result;
}

sub company_data {
	my $self = shift;
	my $db =  App::DB->new()->app_db->db;
  my $result = $db->query('SELECT * FROM company_data')->hash;
  $db->disconnect;
  return $result;
}
1;