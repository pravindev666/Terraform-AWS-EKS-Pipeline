output "endpoint" {
  value = aws_eks_cluster.pravinjob.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.pravinjob.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.pravinjob.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.pravinjob.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.pravinjob.name
}