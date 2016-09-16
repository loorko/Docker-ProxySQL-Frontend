Docker-ProxySQL-Frontend
========================

![ProxySQL Frontned](/images/docker-proxysql-frontend.png)

## Install
Prerequisities
 - Docker

## Build the docker image
```
$ cd Docker-ProxySQL-Frontend
$ docker build -t proxysql-frontend .
```
```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
proxysql-frontend   latest              fb3f76a8ff51        5 seconds ago       424 MB
```

To initialy run:
```
$ docker run -p 8080 -t -i --name proxysql-frontend proxysql-frontend
```
Get the container Ip Address:
```
$ docker inspect --format '{{ .NetworkSettings.IPAddress }}' proxysql-frontend
172.17.0.8
```

Write to the browser:
```
172.17.0.8:8080
```

See it running:
```
$ docker ps
```
```
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                              NAMES
85f4e19becec        proxysql-frontend   "/bin/sh -c 'hypnotoa"   About a minute ago   Up About a minute   0.0.0.0:32772->8080/tcp            proxysql-frontend
```
## Start and Stop

Stop the app running:
```
$ docker stop proxysql-frontend
```
Start the app running again:
```
$ docker start proxysql-frontend
```
## TODO
The default port of 8080