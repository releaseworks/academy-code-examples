region="eu-west-1"
cluster_name="eks-demo"
vpc_name="eks-demo-vpc"
fargate_profile_name="default"
map_users=[
	{
		userarn  = "arn:aws:iam::115341239774:user/eks-admin-nonprod"
		username = "eks-admin-nonprod"
		groups   = ["eks-nonprod-admins"]
	}
]