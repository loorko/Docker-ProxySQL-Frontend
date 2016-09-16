package App;

use Mojo::Base 'Mojolicious';
use Mojo::mysql;
use App::Model;
use App::Controller;
use Try::Tiny;

sub startup {
  my $self = shift;
  $self->setup_plugin;
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

sub setup_model {
  my $self = shift;
  my $model = App::Model->new( mysql => $self->mysql );
  $self->helper(model => sub { $model->model($_[1]) });
}

sub setup_helper {
  my $self = shift;
  
  $self->helper( mysql => sub {
    my $host = $self->config->{database}{host};
    my $port = $self->config->{database}{port};
    my $user = $self->config->{database}{user};
    my $pass = $self->config->{database}{pass};
    
    state $mysql = Mojo::mysql->new;
    $mysql->dsn("dbi:mysql:host=$host;port=$port");
    $mysql->username($user);
    $mysql->password($pass);
  });
}

sub setup_hooks {
  my ($self) = @_;
  $self->hook(before_dispatch => sub {
    my $c = shift;
    try {
      $c->stash( 'admin_version' => $self->model('base')->admin_version() );
    }
    catch {
      $c->stash( 'admin_version' => undef );
      if( $c->req->url->path->to_abs_string ne '/software_setting/proxysql/edit' ){
        $c->redirect_to('/software_setting/proxysql/edit');
      }
    };
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