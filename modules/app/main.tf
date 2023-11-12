# ====================FIRST APP RELEASE WITH HELM====================

resource "helm_release" "app_release" {
  name  = "todo-app-release"
  chart = "./components/chart"

  values = ["${file("./components/chart/values.yaml")}"]

  set {
    name  = "container.image"
    value = "025389115636.dkr.ecr.eu-north-1.amazonaws.com/dev/demo3"
  }

  set {
    name  = "container.tag"
    value = "latest"
  }
}

# ====================INGRESS TO EXPOSE APPLICATION TO THE WEB====================

resource "kubernetes_ingress_v1" "laravel_ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "todo-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/certificate-arn" : var.certificate_arn
      "alb.ingress.kubernetes.io/ssl-redirect" = 443
      "alb.ingress.kubernetes.io/name" : "todo-app-alb"
      "alb.ingress.kubernetes.io/listen-ports" : jsonencode([{ "HTTP" = 80 }, { "HTTPS" = 443 }])
    }
  }

  spec {
    ingress_class_name = "alb"
    default_backend {
      service {
        name = "todo-service"
        port {
          number = 8002
        }
      }
    }
    rule {
      host = "app.${var.domain}"
      http {
        path {
          backend {
            service {
              name = "todo-service"
              port {
                number = 8002
              }
            }
          }
          path = "/*"
        }
      }
    }
  }

  depends_on = [helm_release.app_release]
}

# ====================APPLICATION DNS RECORD====================

data "aws_route53_zone" "hosted_zone" {
  name         = var.domain
  private_zone = false
}

data "aws_lb" "ingress_alb" {
  tags = {
    "ingress.k8s.aws/stack" = "default/todo-ingress"
  }

  depends_on = [kubernetes_ingress_v1.laravel_ingress]
}

resource "aws_route53_record" "app_lb_record" {
  name    = "app.${var.domain}"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "A"

  alias {
    name                   = data.aws_lb.ingress_alb.dns_name
    zone_id                = data.aws_lb.ingress_alb.zone_id
    evaluate_target_health = true
  }
}
