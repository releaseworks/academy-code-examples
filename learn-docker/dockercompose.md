# Docker Compose

### Installing Docker Compose with Linux

To install Docker Compose on Linux including on the WSL use
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Verify it works with 
```
docker-compose --version
```

### Docking Compose

On the WSL you will have to run docker-compose from the windows filesystem for the volume mounts to work
```
cp -r docker-compose/ /c/Users/$USERNAME/Documents/ 
```

Change to that directory and to start the containers run
```
docker-compose up -d
```

To test it's working try
```
curl localhost
```

To stop the containers run
```
docker-compose down
```