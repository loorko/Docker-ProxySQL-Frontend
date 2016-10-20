package Mojolicious::Plugin::FrontendHelpers;
use Mojo::Base 'Mojolicious::Plugin';
use Mojolicious::Plugin::FrontendHelpers::Helpers;
use warnings;
our $VERSION = '0.01';

sub register {
  my ($self, $app, $args) = @_;
  $app->helper('action'     => \&Mojolicious::Plugin::FrontendHelpers::Helpers::action);
  $app->helper('label'      => \&Mojolicious::Plugin::FrontendHelpers::Helpers::label);
  $app->helper('input'      => \&Mojolicious::Plugin::FrontendHelpers::Helpers::input);
  $app->helper('select'     => \&Mojolicious::Plugin::FrontendHelpers::Helpers::select);
  $app->helper('textarea'   => \&Mojolicious::Plugin::FrontendHelpers::Helpers::textarea);
  $app->helper('button'     => \&Mojolicious::Plugin::FrontendHelpers::Helpers::button);
  $app->helper('form_group' => \&Mojolicious::Plugin::FrontendHelpers::Helpers::form_group);
  $app->helper('validation_error' => \&Mojolicious::Plugin::FrontendHelpers::Helpers::validation_error);
}

1;