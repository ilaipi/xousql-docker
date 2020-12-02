# xousql-docker
xo/usql docker

## First, build docker image

if need oracle, please:  
1, [InstallingUnixODBC](https://github.com/alexbrainman/odbc/wiki/InstallingUnixODBC)    
2, [参考“Install Oracle Instant Client and SDK”部分](https://gist.github.com/vicmx/b4968ea72a57def8247fcdb0c51efe28)

put 3 files downloaded to the Dockerfile directory:

```
unixODBC-2.3.1.tar.gz
instantclient-basic-linux.x64-12.1.0.2.0.zip
instantclient-sdk-linux.x64-12.1.0.2.0.zip
```

## And then, build the docker:

```
# build docker
docker build -t xousql .

# if exists
docker rm -f xousql

# run and enter the container
docker run -d --name xousql xousql -f && docker exec -it xousql bash

# mount volume
docker run -d --name xousql -v $PWD/sql:/data/sql xousql

# after mount, you can create sql file to be execute by usql.
```

## At last
you can save the container to a tar file, and transfer to the server without internet but can access your database,

and then load the tar file to run a docker container.

```
docker save -o xosql.tar xosql

docker loda -i xosql.tar xosql
```
