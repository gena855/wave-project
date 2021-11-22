# IAM for nodes group
resource "aws_iam_role" "nodes_group" {
  name               = "eks-node-group"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action"    : "sts:AssumeRole",
          "Effect"    : "Allow",
          "Sid"       : "",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          }
        }
     ]
}
EOF
}
# IAM for nodes group
resource "aws_iam_role_policy_attachment" "worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_group.name
}

resource "aws_iam_role_policy_attachment" "registry_read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_group.name
}

resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "workers"

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  node_role_arn = aws_iam_role.nodes_group.arn

  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME
  subnet_ids = [aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id]

  # Configuration block with scaling settings
  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 2
  }

  ami_type             = "AL2_x86_64"
  capacity_type        = "SPOT"
  disk_size            = 8
  force_update_version = false
  instance_types       = ["t2.small"]

  labels = {
    role = "nodes-general"
  }
  version = "1.21" # Kubernetes version

  depends_on = [
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.eks_cni,
    aws_iam_role_policy_attachment.registry_read,
  ]
}
