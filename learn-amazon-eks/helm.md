# Using Helm with EKS
## Setup
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

## Install Helm

Download the install script, make it executable and run it with:
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Navigate to the helm directory in this repository at `academy-code-examples/learn-amazon-eks/helm/`

To install our chart go to the helm example folder and run:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install wordpress -f values.yaml bitnami/wordpress
```

To upgrade our application change the image tag to `5.4.1-debian-10-r0`. A full list of the configurable values is available in the [bitnami wordpress chart repository.](https://github.com/bitnami/charts/tree/master/bitnami/wordpress)


To update our installed application we can run
```
helm upgrade -f values.yaml wordpress bitnami/wordpress
```

If I run we can see the new values
```
helm get values wordpress
```

To rollback to a previous revision of our wordpress deployment we can run
```
helm rollback wordpress 1
```

To remove our deployment we can run 
```
helm uninstall wordpress
```
Be sure to remove your cluster when you are finished with using
```
eksctl delete cluster --name demo-nodegroup
```
