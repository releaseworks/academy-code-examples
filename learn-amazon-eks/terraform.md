# Creating a cluster with Terraform

## Set up

If you already configured the awscli then you won't have to do this step otherwise make sure you have an administrator user enabled and [programmatic credentials added either in environment variables or in a credentials file.](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

You will also need terraform installed.

## Creating your cluster

Change to the `academy-code-examples/learn-amazon-eks/terraform/nodegroups` directory and run: 
```
terraform init
```
This will download the relevant provider and resource modules.

Then run:
```
terraform plan
```
This will show you what resources will be created when you apply your terraform configuration.

To apply run:
```
terraform apply
```
And type yes when prompted to apply the configuration.

You can try deploying the nodegroup Kubernetes configuration by changing to the `academy-code-examples/learn-amazon-eks/hellonode/nodegroup` folder and running:
```
kubectl apply -f .
```

To view the application endpoint run:
```
kubectl get svc
```

This will display a url with the loadbalancer allowing access to the hellonode application.

When you are done with the cluster make sure you run:
```
terraform destroy
```
To clean up the resources you just created.
