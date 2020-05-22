# Building Docker images

This session requires a second git repository which contains our hellonode application and the configuration to create a Docker image for it. This is available at [https://github.com/releaseworks/hellonode](https://github.com/releaseworks/hellonode) you can clone the repository using 
```
git clone https://github.com/releaseworks/hellonode.git
```

Change to the directory created by cloning the repository with 
```
cd hellonode
```

To run the application use
```
node main.js
```

You may need to install node.js, on ubuntu you can do this with
```
sudo apt install nodejs
```

Edit the application with your text editor of choice
```
nano main.js
```

To build our new container image use the docker build command
```
docker build . -t $USER/hellonode:v1
```

To create a container from our new image run
```
docker run -d -p 8000:8000 --name hello$USER $USER/hellonode:v1
```

Test it's working from the command line with curl
```
curl localhost:8000
```

Remove the container with
```
docker kill hello$USER
```