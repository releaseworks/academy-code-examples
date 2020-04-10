# Managing build dependencies
The example Jenkinsfile for using a build environment image:
```
node {
  docker.image('my-build-deps:1').inside {
    sh 'npm install'
    sh 'bower'
    sh './deploy.sh'
  }
}
```

The example Dockerfile for creating a build environment image:
```
# Use the Node 9 base-image
FROM node:9

# Install webpack version 4.16.5 globally
RUN npm install -g webpack@4.16.5

# Copy the generic deployment script we’ve created
COPY deploy.sh deploy.sh

```