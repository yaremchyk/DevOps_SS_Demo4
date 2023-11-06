resource "kubernetes_deployment" "shareyourtext" {
  metadata {
    name = "demo4"
    labels = {
      App = "demo4"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "demo4"
      }
    }
    template {
      metadata {
        labels = {
          App = "demo4"
        }
      }
      spec {
        container {
          image = "${module.ecr.repository_url}:latest"
          name  = "demo4"

          port {
            container_port = 8002
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "shareyourtext_ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "demo4-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/ssl-redirect" = 443
      "alb.ingress.kubernetes.io/tags": "${keys(var.alb_tag)[0]}=${values(var.alb_tag)[0]}"
      "alb.ingress.kubernetes.io/listen-ports": jsonencode([{"HTTP"=80}, {"HTTPS"=443}])
    }
  }

  spec {
    ingress_class_name = "alb"
    default_backend {
      service {
        name = "demo4"
        port {
          number = 80
        }
      }
    }
    rule {
      host = "app.${var.domain}"
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.shareyourtext_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
          path = "/*"
        }
      }
    }
  }

  depends_on = [
    helm_release.lb,
    kubernetes_service_account.service-account,
    module.lb_role
  ]
}

resource "kubernetes_service_v1" "shareyourtext_service" {
  metadata {
    name = "demo4"
  }

  spec {
    selector = {
      App = "demo4"
    }

    port {
      port        = 80
      target_port = 8002
    }

    type = "NodePort"
  }
}