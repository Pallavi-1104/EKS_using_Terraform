output "nodejs_service_url" {
  value = kubernetes_service.nodejs_service.status[0].load_balancer[0].ingress[0].hostname
}

output "mongo_service_url" {
  value = kubernetes_service.mongo_service.spec[0].cluster_ip
}
