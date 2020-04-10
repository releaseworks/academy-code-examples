# Understanding Jenkins: Running Jenkins locally
To run Jenkins locally via Docker, you will need Docker installed.

This command will mount the host Docker server's Unix socket to the container, and map the port 8080 from the container to the host:
```
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v jenkins-data:/var/jenkins_home -p 8080:8080 getintodevops/jenkins-withdocker:lts-docker18.06.0
```
The image is generated from https://github.com/getintodevops/jenkins-withdocker