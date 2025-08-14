data "digitalocean_volume" "gitea_volume" {
  region                  = var.do_region
  name                    = var.do_volume_name
  description             = "Persistent storage for the gitea server configuration and repo data"
}