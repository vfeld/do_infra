data "digitalocean_domain" "k8s_domain" {
  name   = var.do_domain
}

resource "digitalocean_record" "k8s_record" {
  domain = data.digitalocean_domain.k8s_domain.id
  type   = "A"
  name   = var.do_droplet_name
  value  = digitalocean_droplet.k8s_droplet.ipv4_address
}