# Configuring Jenkins to support Docker
See the lesson for instructions on how to configure Jenkins to work with Docker.

This is a pipeline snippet to test if Docker works:
```
node {
    docker.image('alpine:latest').inside {
        sh 'echo Hello World!'
    }
}
```
