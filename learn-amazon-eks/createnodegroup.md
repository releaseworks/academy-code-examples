
# Create cluster
First create the cluster with the following command:
```
eksctl create cluster \
 --name demo-nodegroup \
 --without-nodegroup
```

Once that has finished we need to create a node group with:
```
eksctl create nodegroup \
--cluster demo-nodegroup \
--version auto \
--name node-group \
--node-type t3.small \
--node-ami auto \
--nodes 2 \
--nodes-min 1 \
--nodes-max 3
```

# Demo Application
Included in this repository is some kubernetes configuration you can use to test your new cluster.

Clone the repository and move to the learn-amazon-eks/hellonode folder
```
git clone https://github.com/releaseworks/academy-code-examples.git
cd academy-code-examples/learn-amazon-eks/hellonode/nodegroups
```

Run kubectl apply on the files in the directory:
`kubectl apply -f .`

Check the deployment was succesful by running:
`kubectl get deployments`

Find the endpoint for your new application by running:
`kubectl get svc`

Remove your application with:
`kubectl delete -f .`

Remove the cluster with:
`eksctl delete cluster --name demo-nodegroup`
