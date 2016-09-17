-- 1 up
CREATE TABLE proxysql_connection (
    id   INT PRIMARY KEY NOT NULL,
    host TEXT NOT NULL,
    port TEXT NOT NULL,
    user TEXT NOT NULL,
    pass TEXT NOT NULL );

INSERT INTO proxysql_connection (id, host, port, user, pass)
VALUES (1, '178.17.0.7', '6032', 'admind', 'admin');

CREATE TABLE company_data (
    id      INT PRIMARY KEY NOT NULL,
    name    TEXT NOT NULL,
    address TEXT NOT NULL );

INSERT INTO company_data (id, name, address)
VALUES (1, 'SysOwn', 'Santa Ana, CA');