# xousql-docker
xo/usql docker

```
# build docker
docker build -t xousql .

# if exists
docker rm -f xousql

# run and enter the container
docker run -d --name xousql xousql -f && docker exec -it xousql bash
```
