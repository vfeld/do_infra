data "digitalocean_volume" "gitea_volume" {
  region                  = var.do_region
  name                    = "giteavolume"
  description             = "Persistent storage for the gitea server configuration and repo data"
}