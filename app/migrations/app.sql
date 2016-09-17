-- 1 up
create table proxysql_connection ( host text, port text, user text, pass text );
insert into proxysql_connection values ('172.17.0.7', '6032', 'admin', 'admin');

create table company_data ( name text, address text );
insert into company_data values ('SysOwn', 'Santa Ana, CA');