resource "digitalocean_droplet" "gitea_droplet" {
  image = var.do_image
  name = "gitea"
  region = var.do_region
  size = var.do_droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.git-user.id
  ]
  user_data = templatefile("gitea_cloud_init.tpl", {
    domain_name = var.do_domain
  })
}

output "VM_IP_ADDR" {
  value = digitalocean_droplet.gitea_droplet.ipv4_address
}