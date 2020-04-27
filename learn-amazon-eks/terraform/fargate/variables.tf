variable "region" {
  default = "eu-west-1"
}

variable "cluster_name" {
	default = "eks-cluster"
}

variable "vpc_name" {
	default = "eks-vpc"
}

variable "fargate_profile_name" {
	default = "eks-nonprod-dev"
}


variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
