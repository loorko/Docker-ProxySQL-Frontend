package App::I18N::hu;
use utf8;
use Mojo::Base 'App::I18N';
our %Lexicon = (
	'Page not found' => 'Odal nem található',
	yes 		=> 'Igen',
	no 			=> 'Nem',
	cancel 	    => 'Mégsem',
	save 		=> 'Mentés',
	'List'		=> 'Listázás',
    'Actions'   => 'Műveletek',
    'Edit'      => 'Szerkesztés',
    'Delete'    => 'Törlés',
    
    'Settings'          => 'Beállítások',
    'Company settings'  => 'Fiók beállításai',
    'Software settings' => 'Szoftver beállításai',
    
    'Dashboard'     => 'Áttekintés',
    'Users'         => 'Felhasználók',
    # MySQL Servers panel
    'MySQL Servers' => 'MySQL Szerverek',
    'Hostgroup id'  => 'Hostgroup id',
    'Hostname'      => 'Hostname',
    'Port'          => 'Port',
    'Status'        => 'Állapot',
    'Weight'        => 'Súly',
    'Compression'           => 'Compression',
    'Max connections'       => 'Max connections',
    'Max replication lag'   => 'Max replication lag',
    'Use ssl'       => 'Use ssl',
    'Max latency'   => 'Max latency',
    'Comment'       => 'Comment',
    
    # MySQL Users panel
    'MySQL Users'       => 'MySQL Felhasználók',
    'New user'          => 'Új felhasználó',
    'Create new user'   => 'Új felhazsnáló létrehozása',
    'User data'         => 'Felhasználó adatai',
    'Username:'         => 'Felhasználónév:',
	# Form validator
	form_error_required => 'Kötelezőmező üresen maradt',
	form_error_size 	=> 'Túl hosszú',
);
1;