output "eks-endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}