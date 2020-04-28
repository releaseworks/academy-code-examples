# How to deploy a Fargate Cluster with eksctl

## Creating the cluster

To create a cluster run the following.
`eksctl create cluster --name demo-fargate --version 1.15 --fargate`

This will take a while to complete but once it does check you can communicate with it by running:
`kubectl get nodes`

## Application Load Balancer configuration

Next we will need to set up the Application Load Balancer configuration to allow your applications to be accessible over the internet.

Create an IAM OIDC providor and associate it with your cluster:
```
eksctl utils associate-iam-oidc-provider \
    --region eu-west-1 \
    --cluster demo-fargate \
    --approve
 ```
 
Then create an IAM policy called ALBIngressControllerIAMPolicy to allow the ALB Ingress Controller pod to make calls to the AWS api and create the ALB's to access your applications, make sure to take note of the policy ARN this outputs:
```
aws iam create-policy \
    --policy-name ALBIngressControllerIAMPolicy \
    --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
```
Create a Kubernetes service account called alb-ingress-controller in the kube-system namespace:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
```

Create an IAM role to allow the ALB Ingress controller that uses the IAM policy we created earlier, make sure you replace the policy ARN with the one you created earlier
```
eksctl create iamserviceaccount \
    --region eu-west-1 \
    --name alb-ingress-controller \
    --namespace kube-system \
    --cluster demo-fargate \
    --attach-policy-arn arn:aws:iam::111122223333:policy/ALBIngressControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --approve
```
Deploy the ALB Ingress Controller pod:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml
```
Edit the pod configuration by running `kubectl edit deployment.apps/alb-ingress-controller -n kube-system` and adding the following lines after the `- --ingress-class=alb` flag
```
    spec:
      containers:
      - args:
        - --ingress-class=alb
        - --cluster-name=demo-fargate
        - --aws-vpc-id=vpc-03468a8157edca5bd
        - --aws-region=eu-west1
```
Check it deployed correctly with:
```
kubectl get pods -n kube-system
```

# Demo Application
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
`kubectl get ingress`

Remove your application with:
`kubectl delete -f ./`

Remove the cluster with:
`eksctl delete cluster --name demo-fargate`
