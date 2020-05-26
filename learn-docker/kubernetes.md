# An introduction to kubernetes

### Setup for Ubuntu on the WSL

To install kubectl on Ubuntu using apt use 
```
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

Enable Kubernetes on the Docker Desktop

Create the directory for you local kube config
```
mkdir ~/.kube
```

And link the windows configuration into the WSL with
```
ln -sf /c/Users/Joe/.kube/config ~/.kube/config
```

Check it's worked by running
```
kubectl get nodes
```

### Kubernetes configuration

Apply all configuration in the learn-docker/kubernetes folder by changing to the directory and running
```
kubectl apply -f .
```

You can see them running with:
```
kubectl describe svc,deployments
```

Check the application is working correctly with:
```
curl localhost
```

You can see more details about the objects deployed using the kubectl describe command:
```
kubectl describe deployment hellonode
```

To see the output of stdout from containers running in a pod you can 'attach' to a pod:
```
kubectl attach $PODNAME
```

Or if you need shell access to debug an issue you can use exec to spawn a shell if one is present in the running container:
```
kubectl exec -it $PODNAME /bin/sh
```

When you are finished with the example objects they can be removed by running the following in the folder form which you deployed them:
```
kubectl delete -f .
```