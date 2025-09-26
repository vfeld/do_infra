data "digitalocean_domain" "domain" {
  name   = var.do_domain
}

resource "digitalocean_record" "record" {
  domain = data.digitalocean_domain.domain.id
  type   = "A"
  name   = var.do_droplet_name
  value  = digitalocean_droplet.droplet.ipv4_address
}