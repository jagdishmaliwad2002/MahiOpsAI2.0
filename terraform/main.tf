terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27.0"
    }
  }
}

# -------------------------------
# Providers
# -------------------------------

provider "docker" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# -------------------------------
# Docker Image (IaC)
# -------------------------------

resource "docker_image" "mahiopsai2" {
  name = "mahiopsai2:latest"

  build {
    context    = "../"
    dockerfile = "docker/Dockerfile"
  }
}

# -------------------------------
# Kubernetes Deployment (IaC)
# -------------------------------

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
          name  = "mahiopsai2"
          image = "mahiopsai2:latest"

          image_pull_policy = "Never"

          port {
            container_port = 5000
          }

          env {
            name  = "DATABASE_URL"
            value = "postgresql://postgres:postgres@host.docker.internal:5432/speedio"
          }
        }
      }
    }
  }
}
