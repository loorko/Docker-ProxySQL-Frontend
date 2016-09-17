package App::Model::Base;
use Mojo::Base -base;

has 'proxy_db';
has 'app_db';

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
	shift->app_db->db->query('SELECT * FROM proxysql_connection')->hash;
}

sub company_data {
	shift->app_db->db->query('SELECT * FROM company_data')->hash;
}

sub admin_version {
	shift->proxy_db->db->query('SELECT variable_value FROM global_variables WHERE variable_name = "admin-version"')->hash->{variable_value};
}
1;