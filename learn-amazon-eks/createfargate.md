# How to deploy a Fargate Cluster with eksctl

To create a cluster run the following.
`eksctl create cluster --name demo-fargate --version 1.15 --fargate`

This will take a while to complete but once it does check you can communicate with it by running:
`kubectl get nodes`

Included in this repository is some kubernetes configuration you can use to test your new cluster.

Clone the repository and move to the learn-amazon-eks/hellonode folder
```
git clone https://github.com/releaseworks/academy-code-examples.git
cd academy-code-examples/learn-amazon-eks/hellonode
```

Run kubectl apply on the files in the directory:
`kubectl apply -f ./`

Check the deployment was succesful by running:
`kubectl get deployments svc`

Find the endpoint for your new application by running:
`kubectl describe svc`

Remove your application with:
`kubectl delete -f ./`

Remove the cluster with:
`eksctl delete cluster --name demo-fargate`
