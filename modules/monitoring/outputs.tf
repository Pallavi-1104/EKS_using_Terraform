output "prometheus_url" {
  description = "URL of Prometheus server"
  value       = "http://prometheus-server.monitoring.svc.cluster.local"
}

output "grafana_url" {
  description = "URL of Grafana server"
  value       = "http://grafana.monitoring.svc.cluster.local"
}
