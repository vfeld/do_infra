resource "digitalocean_volume" "gitea_volume" {
  region                  = var.do_region
  name                    = "giteavolume"
  size                    = 100
  initial_filesystem_type = "ext4"
  description             = "Persistent storage for the gitea server configuration and repo data"
}