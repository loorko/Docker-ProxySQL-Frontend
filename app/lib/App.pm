package App;

use Mojo::Base 'Mojolicious';
use Mojo::SQLite;
use Mojo::mysql;
use App::Model;
use App::Controller;
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
  my $model = App::Model->new( proxy_db => $self->proxy_db, app_db => $self->app_db );
  $self->helper(model => sub { $model->model($_[1]) });
}

sub setup_helper {
  my $self = shift;

  $self->helper( app_db => sub {
    my $app_database_name = $self->config->{app_database_name};
    state $app_db = Mojo::SQLite->new("sqlite:$app_database_name");
  });
  $self->helper( proxy_db => sub {
    my $proxysql_connection = $self->app_db->db->query('SELECT * FROM proxysql_connection')->hash;
    say Dumper( $proxysql_connection );
    
    my $host = $proxysql_connection->{host};
    my $port = $proxysql_connection->{port};
    my $user = $proxysql_connection->{user};
    my $pass = $proxysql_connection->{pass};
    
    state $proxy_db = Mojo::mysql->new();
    $proxy_db->dsn("dbi:mysql:host=$host;port=$port");
    $proxy_db->username($user);
    $proxy_db->password($pass);
  });
}

sub setup_hooks {
  my ($self) = @_;
  $self->hook( before_dispatch => sub {
    my $c = shift;

    my $proxysql_connection = $self->model('base')->proxysql_connection();
    my $p = Net::Ping->new();
       $p->port_number($proxysql_connection->{port});
    
    # Host is aliven
    if( $p->ping($proxysql_connection->{host}, 3) ){
      try {
        $c->stash( 'admin_version' => $self->model('base')->admin_version() );
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