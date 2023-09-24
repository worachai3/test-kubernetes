provider "kubernetes" {
  host = "https://9441-2001-fb1-c1-f45c-e870-16e9-6dcd-3eb6.ngrok-free.app/"
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_deployment" "test" {
  metadata {
    name = "nginx"
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "MyTestApp"
      }
    }

    template {
      metadata {
        labels = {
          App = "MyTestApp"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx-container"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test" {
  metadata {
    name = "nginx"
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.test.spec[0].template[0].metadata[0].labels.App
    }
    type = "NodePort"
    port {
      node_port = 30201
      port = 80
      target_port = 80
    }
  }
}