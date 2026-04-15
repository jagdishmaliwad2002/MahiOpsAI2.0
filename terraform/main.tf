# -----------------------------
# 1. Provider (connect to Kubernetes)
# -----------------------------
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# -----------------------------
# 2. Deployment (run your app)
# -----------------------------
resource "kubernetes_deployment" "mahiopsai2" {

  metadata {
    name = "mahiopsai2-tf"

    labels = {
      app = "mahiopsai2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mahiopsai2"
      }
    }

    template {
      metadata {
        labels = {
          app = "mahiopsai2"
        }
      }

      spec {
        container {
          name  = "app"
          image = "jack9005/mahiopsai:latest"

          image_pull_policy = "Always"

          port {
            container_port = 5000
          }

          env {
            name  = "DATABASE_URL"
            value = "postgresql://postgres:postgres@postgres:5432/speedio"
          }
        }
      }
    }
  }
}

# -----------------------------
# 3. Service (expose app)
# -----------------------------
resource "kubernetes_service" "mahiopsai2_service" {

  metadata {
    name = "mahiopsai2-service"
  }

  spec {
    selector = {
      app = "mahiopsai2"
    }

    port {
      port        = 5000
      target_port = 5000
      node_port   = 30008
    }

    type = "NodePort"
  }
}
