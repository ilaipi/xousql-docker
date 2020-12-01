# xousql-docker
xo/usql docker

## download oracle client (if need oracle)
[参考“Install Oracle Instant Client and SDK”部分](https://gist.github.com/vicmx/b4968ea72a57def8247fcdb0c51efe28)

```
# build docker
docker build -t xousql .

# if exists
docker rm -f xousql

# run and enter the container
docker run -d --name xousql xousql -f && docker exec -it xousql bash
```
