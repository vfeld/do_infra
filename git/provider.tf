terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "local" {
  # Configuration options
}