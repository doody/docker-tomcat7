docker-tomcat7
============================

```
docker pull wnameless/tomcat7
```

Run with 22 an 8080 ports opened:
```
docker run -d -p 49160:22 -p 49161:8080 wnameless/tomcat7
```

Open http://localhost:49161/manager/html in your browser with following credential:
```
username: admin
password: admin
```

Login by SSH
```
ssh root@localhost -p 49160
password: admin
```
