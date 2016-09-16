package App;

use Mojo::Base 'Mojolicious';
use Mojo::mysql;
use App::Model;
use App::Controller;

my $VERSION = '0.0.1';

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
            # As "defaults" values are not deep-copied, setting a hashref there
            # would just copy that hashref and stash modifications would actually
            # modify the defaults.
            $c->stash(info  => []);
            $c->stash(error => []);

            # Debug request logging
            my $req    = $c->req;
            my $method = $req->method;
            my $path   = $req->url->path->to_abs_string;
            my $params = $req->params->to_string;
            print STDERR "REQ  : $method $path [$params]\n";
        });
}
sub setup_routing {
  my $self = shift;
  my $r = $self->routes;

  $r = $r->namespaces(['App::Controller']);
  
  $r->add_condition(
    menu => sub {
      my ($route, $c, $captures, $arg) = @_;
      my $menu = $self->model('base')->menu();
      $c->stash( 'menu' => $menu );
      return 1;
    }
  );
  
# Start page
  $r->route('/')->via('get')
    ->to( controller  => 'main',
          action      => 'index' );

# Account
  $r->route('/account')->via('get')
    ->over( menu => 1 )
    ->to( controller  => 'account',
          action      => 'read',
          template    => 'account/read' );

  $r->route('/account/edit')->via('get')
    ->over( menu => 1 )
    ->to( controller  => 'account',
          action      => 'read',
          template    => 'account/edit' );

# Dashboard
  $r->route('/main')->via('get')
    ->over( menu => 1 )
    ->to( controller  => 'main',
          action      => 'main',
          template    => 'main/main' );

# Users
  $r->route('/users')->via('get')
    ->over( menu => 1 )
    ->to( controller  => 'users',
          action      => 'list',
          template    => 'users/list' );
    
  $r->route('/user')->via('get')
    ->over( menu => 1 )
    ->to( controller  => 'users',
          action      => 'form',
          template    => 'users/form' );

  $r->route('/user')->via('post')
    ->over( menu => 1 )
    ->to( controller  => 'users',
          action      => 'create',
          template    => 'users/form' );
}
1;