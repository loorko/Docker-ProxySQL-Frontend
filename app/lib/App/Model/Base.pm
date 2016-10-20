package App::Model::Base;
use Mojo::Base 'MojoX::Model';

sub menu {
  my $self = shift;
  my $menu;

  $menu = [ { 'name'    => 'Dashboard',
              'action'  => '/main',
              'icon'    => 'dashboard'},
            { 'name'    => 'Users',
              'action'  => '/users',
              'icon'    => 'users'}];
  return $menu;
}

sub proxysql_connection {
  my $self   = shift;
  my $db     =  App::DB->new()->app_db->db;
  my $result = $db->query('SELECT * FROM proxysql_connection')->hash;
  $db->disconnect;
  return $result;
}

sub company {
  my $self   = shift;
  my $db     =  App::DB->new()->app_db->db;
  my $result = $db->query('SELECT * FROM company_data')->hash;
  $db->disconnect;
  return $result;
}

sub proxysql_version {
  my $self   = shift;
  my $db     =  App::DB->new()->proxy_db->db;
  my $result = $db->query('SELECT variable_value FROM global_variables WHERE variable_name = "admin-version"')->hash->{variable_value};
  $db->disconnect;
  return $result;
}
1;