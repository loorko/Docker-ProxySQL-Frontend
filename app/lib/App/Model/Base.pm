package App::Model::Base;
use Mojo::Base -base;

has 'mysql';

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

sub admin_version {	
	shift->mysql->db->query('SELECT variable_value FROM global_variables WHERE variable_name = "admin-version"')->hash->{variable_value};
}
1;