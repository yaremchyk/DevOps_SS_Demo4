# ====================KMS KEY====================

resource "aws_kms_key" "eks_kms_key" {
  description         = "KMS key for EKS"
  enable_key_rotation = true

  tags = merge(var.tags, tomap({ "Name" = "${var.env}-eks-kms-key" }))
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_eks_cluster" "demo_cluster" {
  name = aws_eks_cluster.demo_cluster.name
}

data "aws_eks_cluster_auth" "demo_cluster" {
  name = aws_eks_cluster.demo_cluster.name
}


# ====================EKS CLUSTER====================

resource "aws_eks_cluster" "demo_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.demo_eks_role.arn
  version  = "1.23"

  vpc_config {
    subnet_ids              = data.aws_subnets.subnets.ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.eks_api_private_access.id]
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_kms_key.arn
    }
    resources = ["secrets"]
  }


  tags = merge(var.tags, tomap({ "Name" = var.cluster_name }))

  depends_on = [
    aws_iam_role_policy_attachment.demo_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo_AmazonEKSVPCResourceController,
  ]
}

# ====================NODE GROUP====================

resource "aws_eks_node_group" "demo_node" {
  cluster_name    = aws_eks_cluster.demo_cluster.name
  node_group_name = "demo_node_group"
  node_role_arn   = aws_iam_role.demo_node_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo_node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo_node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo_node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# ====================ADD-ONS====================

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.demo_cluster.name
  addon_name   = "vpc-cni"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.tags, tomap({ "Name" = "vpc-cni" }))

  depends_on = [
    aws_eks_node_group.demo_node
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.demo_cluster.name
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.tags, tomap({ "Name" = "coredns" }))

  depends_on = [
    aws_eks_node_group.demo_node
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.demo_cluster.name
  addon_name        = "kube-proxy"
  resolve_conflicts = "OVERWRITE"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.tags, tomap({ "Name" = "kube-proxy" }))

  depends_on = [
    aws_eks_node_group.demo_node
  ]
}

# ==========ENSURING USE OF IAM ROLES INSIDE CLUSTER==========

data "tls_certificate" "demo_tls" {
  url = aws_eks_cluster.demo_cluster.identity[0].oidc[0].issuer

  depends_on = [
    aws_eks_cluster.demo_cluster,
    aws_security_group_rule.inbound_rule_allow_https
  ]
}

resource "aws_iam_openid_connect_provider" "demo_openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.demo_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo_cluster.identity[0].oidc[0].issuer
}

# ==========NULL RESOURCE FOR AUTOMATIC KUBECONFIG UPDATES==========

resource "null_resource" "config_update" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name}"
  }
  depends_on = [
    aws_eks_node_group.demo_node
  ]
}
