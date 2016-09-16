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
1;