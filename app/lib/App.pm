package App;

use Mojo::Base 'Mojolicious';
use Mojo::SQLite;
use Mojo::mysql;
use App::Model;
use App::Controller;
use App::DB;
use Try::Tiny;
use Net::Ping;
use Data::Dumper;

sub startup {
  my $self = shift;
  $self->setup_plugin;
  $self->setup_init;
  $self->setup_helper;
  $self->setup_model;
  $self->controller_class('App::Controller');
  $self->setup_routing;
  $self->setup_hooks;
}

sub setup_plugin {
  my $self = shift;
  $self->plugin('Config' => { file => 'app.conf' });
  $self->plugin('I18N' => { default => $self->config->{default_language} });
}

sub setup_init {
  my $self = shift;
  my $path = $self->home->rel_file('migrations/app.sql');
  my $app_database_name = $self->config->{app_database_name};
  Mojo::SQLite->new("sqlite:$app_database_name")->migrations->from_file($path)->migrate;
};

sub setup_model {
  my $self = shift;
  my $model = App::Model->new();
  $self->helper(model => sub { $model->model($_[1]) });
}

sub setup_helper {
  my $self = shift;
}

sub setup_hooks {
  my ($self) = @_;
  $self->hook( before_dispatch => sub {
    my $c = shift;
    say 'hook';
    my $proxysql_connection = $self->model('base')->proxysql_connection();
    my $p = Net::Ping->new();
       $p->port_number($proxysql_connection->{port});
    
    # Host is aliven
    if( $p->ping($proxysql_connection->{host}, 3 ) ){
      try {
        my $check_proxysql_connection = App::DB->new()->check_proxysql_connection();
        $c->stash( 'admin_version' => $check_proxysql_connection );
      }
      catch {
        $c->stash( 'admin_version' => undef );
        if( $c->req->url->path->to_abs_string ne '/software_setting/proxysql/edit' ){
          $c->redirect_to('/software_setting/proxysql/edit');
        }
      };
    }
    else{
      $c->stash( 'admin_version' => undef );
      if( $c->req->url->path->to_abs_string ne '/software_setting/proxysql/edit' ){
        $c->redirect_to('/software_setting/proxysql/edit');
      }
    }
    $p->close();
    
    $c->stash( 'proxysql_connection' => $proxysql_connection );
    $c->stash( 'company_data' => $self->model('base')->company_data() );
    $c->stash( 'menu' => $self->model('base')->menu() );
  });
};

sub setup_routing {
  my $self = shift;
  my $r = $self->routes;

  $r = $r->namespaces(['App::Controller']);
  
# Start page
  $r->route('/')->via('get')
    ->to( controller  => 'main',
          action      => 'index' );

# Software settings
  $r->route('/software_setting')->via('get')
    ->to( controller  => 'software_setting',
          action      => 'show',
          template    => 'software_setting/show' );
    
  $r->route('/software_setting/proxysql/edit')->via('get')
    ->to( controller  => 'software_setting',
          action      => 'get_proxysql',
          template    => 'software_setting/form/proxysql' );
  
  $r->route('/software_setting/proxysql/edit')->via('post')
    ->to( controller  => 'software_setting',
          action      => 'post_proxysql',
          template    => 'software_setting/form/proxysql' );
    
# Dashboard
  $r->route('/main')->via('get')
    ->to( controller  => 'main',
          action      => 'main',
          template    => 'main/main' );

# Users
  $r->route('/users')->via('get')
    ->to( controller  => 'user',
          action      => 'list',
          template    => 'user/list' );
    
  $r->route('/user')->via('get')
    ->to( controller  => 'user',
          action      => 'form',
          template    => 'user/form' );

  $r->route('/user')->via('post')
    ->to( controller  => 'user',
          action      => 'create',
          template    => 'user/form' );
}
1;