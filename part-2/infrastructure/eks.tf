# IAM role for EKS
resource "aws_iam_role" "eks_cluster" {
  name               = "eks-cluster" # The name of the role
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action"    : "sts:AssumeRole",
        "Effect"    : "Allow",
        "Sid"       : "",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        }
      }
    ]
}
EOF
}
# IAM role for EKS
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}


# EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = "eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.21"
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    # Subnets in 2 AZ
    subnet_ids = [
      aws_subnet.private-subnet-a.id,
      aws_subnet.private-subnet-b.id,
    ]

  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}
