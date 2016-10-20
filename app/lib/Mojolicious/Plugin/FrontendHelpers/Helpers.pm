package Mojolicious::Plugin::FrontendHelpers::Helpers;
use warnings;
use Mojo::ByteStream;

our $VERSION = '0.01';

sub action {
  my $c    = shift;
  return out($c->req->url->path);
}

sub label {
  my $c    = shift;
  my $arg  = shift;
  my $label   = $arg->{'label'} || undef;
  my $class   = $arg->{'class'} || 'control-label text-semibold';
  my $id      = $arg->{'id'} || undef;
  my $req     = $arg->{'req'} || '';
  my $res     = '';

  if( $label ){ $label = $c->l($label) };
  if( $req ){ $req = '<span class="text-danger">*</span>' };

  $res = "<label "._add_arg('class', $class).""._add_arg('id', $id).">".$label." ".$req."</label>";

  return out($res);
}
sub input {
  my $c   = shift;
  my $arg = shift;
  my $res           = undef;
  my $class         = $arg->{'class'} || 'form-control';
  my $id            = $arg->{'id'} || undef;
  my $placeholder   = $arg->{'placeholder'} || undef;
  if( $placeholder ){ $placeholder = $c->l($placeholder) };
  my $type          = $arg->{'type'} || "text";
  my $name          = $arg->{'name'};
  my $readonly      = $arg->{'readonly'} || undef;
  my $disabled      = $arg->{'disabled'} || undef;
  my $default       = undef;
  if( exists $arg->{'default'} and defined $arg->{'default'}){
    $default       = $arg->{'default'};
  }
  my $data          = $arg->{'data'} || undef;
  my $value         = _value($c,$name,$default,$data);
  
  $res = "<input "._add_arg('class', $class).""._add_arg('id', $id).""._add_arg('placeholder', $placeholder).""._add_arg('type', $type).""._add_arg('name', $name).""._add_arg('value', $value).""._add_arg('readonly', $readonly).""._add_arg('disabled', $disabled).">";
  return out($res);
}
sub select {
  my $c      = shift;
  my $arg    = shift;
  my $res    = '';
  my $option = '';
  my $class         = $arg->{'class'} || 'form-control';
  my $id            = $arg->{'id'} || undef;
  my $name          = $arg->{'name'};
  my $values        = $arg->{'values'};
  my $transalte     = $arg->{'transalte'} || 0;
  my $default       = $arg->{'default'} || undef;
  my $data          = $arg->{'data'} || undef;
  my @path = split(/\./,$data);
  
  if(defined $c->stash($path[0]) and defined $c->stash($path[0])->{$path[1]}){
    $data = $c->stash($path[0])->{$path[1]};
  }
  
  foreach my $opt ( @$values ){
    my $selected      = undef;
    my ($key, $value) = each %$opt;
    if( $transalte ){ $key = $c->l($key) }
    
    if( defined $c->param($name) and $value eq $c->param($name) ){
      $selected = 'selected';
    }
    elsif( defined $data and $data eq $value ){
      $selected = 'selected';
    }
    elsif( defined $default and $default eq $value ){
      $selected = 'selected';
    }
    $option .= '<option value="'.$value.'"'._add_arg('selected', $selected).'>'.$key.'</option>';
  }
  
  $res = "<select "._add_arg('class', $class).""._add_arg('id', $id).""._add_arg('name', $name).">".$option."</select>";
  
  return out($res);
}

sub textarea {
  my $c   = shift;
  my $arg = shift;
  my $res           = undef;
  my $class         = $arg->{'class'} || 'form-control';
  my $id            = $arg->{'id'} || undef;
  my $placeholder   = $arg->{'placeholder'} || undef;
  if( $placeholder ){ $placeholder = $c->l($placeholder) };
  my $name          = $arg->{'name'};
  my $default       = $arg->{'default'} || undef;
  my $data          = $arg->{'data'} || undef;
  my $rows          = $arg->{'rows'} || 2;
  my $value         = _value($c,$name,$default,$data);
  
  $res = "<textarea "._add_arg('class', $class).""._add_arg('id', $id).""._add_arg('placeholder', $placeholder).""._add_arg('name', $name).""._add_arg('rows', $rows).">".$value."</textarea>";
  return out($res);
}

sub validation_error {
  my $c      = shift;
  my $arg    = shift;
  my $res    = '';
  my $name   = $arg->{'name'};
  my $helper = $arg->{'helper'} || undef;
  my $err    = $c->validation->error($name);
  
  if( $c->validation->error($name) ){
    $res = "<span class=\"help-block\">".$c->l( 'form_error_'.$err->[0] )."</span>";
  }
  elsif( $helper ){
    $res = "<span class=\"help-block\">".$c->l($helper)."</span>";
  }
  return out($res);
}

#  Nincs kész
#<%= form_group { name  => 'first_name',
#                 data  => 'person.first_name',
#                 req	 => 1,
#                 label => 'First name:',
#                 input => { placeholder => 'First name' }
#                } %>
sub form_group {
  my $c    = shift;
  my $arg  = shift;
  my $class         = $arg->{'class'} || 'form-group';
  my $label         = $arg->{'label'} || undef;
  my $req           = $arg->{'req'} || undef;
  
  my $name          = $arg->{'name'};
  my $default       = $arg->{'default'} || undef;
  my $data          = $arg->{'data'} || undef;
  
  my $f_label            = label($c, { label => $label, req => $req });
  my $f_validation_error = label($c, { name => $name });
  
  $res = "<div"._add_arg('class', $class).">"
        . $f_label." ". $f_validation_error .
          "</div>";
    
  return out($res);
}

sub button {
  my $c     = shift;
  my $arg   = shift;
  my $type  = $arg->{'type'} || undef;
  my $route = $arg->{'route'} || undef;
  my $data  = $arg->{'data'} || undef;
      
  if( $type eq "reset"){
    return out( btn_reset($c) );
  }
  elsif( $type eq "save"){
    return out( btn_save($c) );
  }
  elsif( $type eq "cancel"){
    return out( btn_cancel( $c, { route => $route, data => $data }) );
  }
  return;
}
sub btn_reset {
  my $c = shift;
  my $text = $c->l('Reset');
  return '<button id="reset" class="btn btn-default pull-left legitRipple" type="reset">'.$text.'<i class="icon-reload-alt position-right"></i></button>';
}
sub btn_cancel {
  my $c     = shift;
  my $arg   = shift;
  my $route = $arg->{'route'} || undef;
  my $data  = $arg->{'data'} || undef;
  my $text  = $c->l('Cancel');
  my $res = '';
  my @path;
  
  if( defined $data  ){
    my @path = split(/\./,$data);
    if( defined $c->stash($path[0]) and defined $c->stash($path[0])->{$path[1]} ){
      $res = '<a class="btn btn-primary btn-labeled btn-labeled-right legitRipple" href="'.$route->{a}.'/'.$c->stash($path[0])->{$path[1]}.'">'.$text.'<b><i class="icon-x"></i></b></a>';
    }
    else{
      $res = '<a class="btn btn-primary btn-labeled btn-labeled-right legitRipple" href="'.$route->{b}.'">'.$text.'<b><i class="icon-x"></i></b></a>';
    }
  }
  return $res;
}
sub btn_save {
  my $c = shift;
  my $text = $c->l('Save');
  return '<button class="btn btn-success btn-labeled btn-labeled-right legitRipple" type="submit">'.$text.'<b><i class="icon-floppy-disk"></i></b></button>';
}
sub _add_arg {
  my $type  = shift;
  my $param = shift;
  my $res    = '';
  if( defined $param ){ $res = qq{ $type="$param"} }
  return $res;
}
sub _value {
  my $c       = shift;
  my $name    = shift;
  my $default = shift;
  my $data    = shift;
  my $res     = "";
  my @path = split(/\./,$data);
  
  if ( $c->param($name) ){
    $res = $c->param($name);
  }
  elsif( defined $c->stash($path[0]) and defined $c->stash($path[0])->{$path[1]} ){
    $res = $c->stash($path[0])->{$path[1]};
  }
  elsif( defined $default ){
    $res = $default;
  }
  return $res;
}

sub out {
  my $tag = shift;
  return Mojo::ByteStream->new($tag);
}
1;