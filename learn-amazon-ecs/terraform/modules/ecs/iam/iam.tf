resource "aws_iam_role" "role" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "${var.service}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
