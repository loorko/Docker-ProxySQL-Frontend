package App;

use Mojo::Base 'Mojolicious';
use App::Model;
use App::Controller;
use App::DB;
use Try::Tiny;

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
  Mojo::SQLite->new("sqlite:app.db")->migrations->from_file($path)->migrate;
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