package App::I18N::hu;
use utf8;
use Mojo::Base 'App::I18N';
our %Lexicon = (
  'Page not found' => 'Odal nem található',
  'Yes'     => 'Igen',
  'No'      => 'Nem',
  'Cancel' 	=> 'Mégsem',
  'List'    => 'Listázás',
  'Actions' => 'Műveletek',
  'View'    => 'Megtekintés',
  'Edit'    => 'Szerkesztés',
  'Save'    => 'Mentés',
  'Delete'  => 'Törlés',
    
  # Menu
  'Settings'              => 'Beállítások',
      'Global settings'   => 'Globális beállítások',
      'Software settings' => 'Szoftver beállításai',
  'Dashboard'             => 'Áttekintés',
  'Users'                 => 'Felhasználók',
    
  # Company panel
  'Company data'  => 'Cég adatai',
      'Company name:'     => 'Cég neve',
      'Company address:'  => 'Cég címe:',
      'Company logo url:' => 'Cég logójának URL-je:',
    
  'ProxySQL data' => 'ProxySQL adatai',
      'ProxySQL host:'    => 'ProxySQL host:',
      'ProxySQL port:'    => 'ProxySQL port:',
      'ProxySQL user:'    => 'ProxySQL felhasználó:',
      'ProxySQL password:'=> 'ProxySQL jelszó:',
  'Edit ProxySQL data'    => 'ProxySQL adatainak módosítása',
    
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
  form_error_required             => 'Kötelezőmező üresen maradt',
  form_error_size 	            => 'Túl hosszú',
  form_error_invalid_host_address => 'Nem megfelelő host cím',
  form_error_invalid_port         => 'Nem megfelelő port'
);
1;