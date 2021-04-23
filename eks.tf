resource "aws_eks_cluster" "basic" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-basic.arn

  version = "1.19"

  vpc_config {
    subnet_ids = [
      aws_subnet.public-nat-1.id,
      aws_subnet.public-nat-2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.basic-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.basic-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.basic.endpoint
}

resource "aws_eks_node_group" "basic" {
  cluster_name    = aws_eks_cluster.basic.name
  node_group_name = "eks-basic-ng"
  node_role_arn   = aws_iam_role.ng-basic.arn
  subnet_ids      = [
    aws_subnet.public-nat-1.id,
    aws_subnet.public-nat-2.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.ng-basic-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.ng-basic-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.ng-basic-AmazonEC2ContainerRegistryReadOnly,
  ]
}
