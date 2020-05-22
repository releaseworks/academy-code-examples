# Using a Docker Registry

To authenticate with docker hub use
```
Docker Login
```

To publish a docker container you must tag it with your Docker Hub username. You can build a new version of the hellonode container tagged with your Docker Hub username with:
```
docker build . -t $dockerhubusername/hellonode:v1
```
Replacing $dockerhubusername with your Docker Hub username

To push to Docker Hub use:
```
Docker push . -t $dockerhubusername/hellonode:v1
```

Again replacing $dockerhubusername with your Docker Hub username