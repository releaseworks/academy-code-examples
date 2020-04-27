# How to install eksctl on Ubuntu

Install the awscli:
`sudo apt install awscli`

Create an IAM account with programmatic access with administrator access to your aws account.

Run aws configure and include your newly created credentials and the region you wish to use. We use eu-west-1 as it supports EKS with Fargate.
```
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: eu-west-1
Default output format [None]: json
```

Check the awcli has been configured correctly by running the following command and making sure it returns json with no errors:
`aws ec2 describe-regions`


Download eksctl and move it into /usr/local/bin:
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

Check eksctl has installed correctly by running:
`eksctl version`

Download and install kubectl with:
```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
```

And install the aws-iam-authenticator:
```
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo mv ./aws-iam-authenticator /usr/local/bin
```

