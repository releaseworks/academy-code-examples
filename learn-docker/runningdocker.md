To check that docker is installed correctly let’s try: 
```
docker run hello-world
```

To run our daemonized container run:
```
docker run -d --name hellodaemon releaseworks/hellonode:f51b051
```

To kill the container we can use:
```
docker kill hellodaemon
```

To run the container again exposing port 8000 on our local machine run:
```
docker run -p 8000:8000 -d --name hellodaemon releaseworks/hellonode:f51b051
```

To check that worked we can try curl
```
curl localhost:8000
```

We should see the output `hello www.releaseworksacademy.com`

When we're finished we can kill the container in the same way with:
```
docker kill hellodaemon
```