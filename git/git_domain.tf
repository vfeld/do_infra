data "digitalocean_domain" "git_domain" {
  name   = var.do_domain
}

resource "digitalocean_record" "git_record" {
  domain = data.digitalocean_domain.git_domain.id
  type   = "A"
  name   = var.do_droplet_name
  value  = digitalocean_droplet.git_droplet.ipv4_address
}