resource "kubernetes_deployment" "nodejs_app" {
  metadata {
    name = "nodejs-app"
    labels = {
      app = "nodejs"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nodejs"
      }
    }

    template {
      metadata {
        labels = {
          app = "nodejs"
        }
      }

      spec {
        container {
          name  = "nodejs"
          image = "<ECR_REPOSITORY_URI>/nodejs:latest"
          port {
            container_port = 3000
          }
          env {
            name  = "MONGO_URI"
            value = "mongodb://mongo:27017/mydb"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name = "mongo"
    labels = {
      app = "mongo"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongo"
        }
      }

      spec {
        container {
          name  = "mongo"
          image = "mongo:latest"
          port {
            container_port = 27017
          }
          volume_mount {
            name      = "mongo-data"
            mount_path = "/data/db"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mongo_pvc" {
  metadata {
    name = "mongo-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_service" "nodejs_service" {
  metadata {
    name = "nodejs-service"
  }

  spec {
    selector = {
      app = "nodejs"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "mongo_service" {
  metadata {
    name = "mongo-service"
  }

  spec {
    selector = {
      app = "mongo"
    }

    port {
      protocol    = "TCP"
      port        = 27017
      target_port = 27017
    }

    cluster_ip = "None"
  }
}
