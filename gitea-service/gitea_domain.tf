data "digitalocean_domain" "gitea_domain" {
  name   = var.do_domain
}

resource "digitalocean_record" "gitea_record" {
  domain = data.digitalocean_domain.gitea_domain.id
  type   = "A"
  name   = var.do_droplet_name
  value  = digitalocean_droplet.gitea_droplet.ipv4_address
}