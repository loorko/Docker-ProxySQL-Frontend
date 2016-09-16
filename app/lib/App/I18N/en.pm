package App::I18N::en;
use utf8;
use Mojo::Base 'App::I18N';
our %Lexicon = (
	# Form validator
	form_error_required             => 'Requied input',
	form_error_size 	            => 'Too long',
    form_error_invalid_host_address => 'Invalid host address',
    form_error_invalid_port         => 'Invalid port'
);
1;