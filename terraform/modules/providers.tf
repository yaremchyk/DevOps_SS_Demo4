terraform {
    required_version = ">= 1.3"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 4.48.0"
        }

        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = ">= 2.16.1"
        }
    }
}
