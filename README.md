## Perfect Golang developement environment.
https://hub.docker.com/r/canhlinh/nginx-mysql-golang/   

### Components.
```
nginx 1.10
mysql 5.7
golang 1.6 -> Support later.
phpMyAdmin latest
```

### Installation
```
docker pull canhlinh/nginx-mysql-golang
```
### Usage
```
docker run canhlinh/nginx-mysql-golang
docker ps
docker inspect {containerid}
```
### Explanation
Enter `docker inspect {containerid}` to see what container's ip address.
Enter container's ip address in your browser to signin into phpMyAdmin
Default root password is `changeme`

### Set default root password
`docker run -e MYSQL_ROOT_PASSWORD {password} -d canhlinh/nginx-mysql-golang`
## Support golang
```
Working on process.
```
