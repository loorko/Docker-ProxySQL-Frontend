package App;

use Mojo::Base 'Mojolicious';
use App::Controller;
use App::DB;
use Try::Tiny;

sub startup {
  my $self = shift;
  $self->setup_plugin;
  $self->setup_init;
  $self->controller_class('App::Controller');
  $self->setup_routing;
}

sub setup_plugin {
  my $self = shift;
  $self->plugin('Config' => { file        => 'app.conf' });
  $self->plugin('I18N'   => { default     => $self->config->{default_language} });
  $self->plugin('Model'  => { namespaces  => ['App::Model'] });
  $self->plugin('Mojolicious::Plugin::FrontendHelpers');
}

sub setup_init {
  my $self = shift;
  my $path = $self->home->rel_file('migrations/app.sql');
  App::DB->new()->app_db->migrations->from_file($path)->migrate;
};

sub setup_routing {
  my $self = shift;
  my $r = $self->routes;

  $r = $r->namespaces(['App::Controller']);

# Root
  $r->route('/')->via('get')
  ->to( 'main#index' );

  my $proxsql = $r->under->to( 'base#check_proxysql_connection' );

# Software settings
  $proxsql->route('/software_setting')->via('get')
  ->to( 'software_setting#show', template => 'software_setting/show' );
    
  $proxsql->route('/software_setting/proxysql/edit')->via('get')
  ->to( 'software_setting#get_proxysql', template => 'software_setting/form/proxysql' );
  
  $proxsql->route('/software_setting/proxysql/edit')->via('post')
  ->to( 'software_setting#update_proxysql', template => 'software_setting/form/proxysql' );
    
# Dashboard
  $proxsql->route('/main')->via('get')
  ->to( 'main#main', template => 'main/main' );
  
# Users
  $proxsql->route('/users')->via('get')
  ->to( 'user#list', template => 'user/list' );

  $proxsql->route('/user')->via('get')
  ->to( 'user#form', template => 'user/form' );
}
1;