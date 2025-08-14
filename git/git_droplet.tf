resource "digitalocean_droplet" "git_droplet" {
  image = var.do_image
  name = var.do_droplet_name
  region = var.do_region
  size = var.do_droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.do_master_ssh_key.id
  ]
  user_data = templatefile("git_cloud_init.tpl", {
    admin_user = var.do_admin_user
    pub_ssh_key = data.local_file.pub_ssh_key_file.content
    droplet_name = var.do_droplet_name
  })
}

data "digitalocean_ssh_key" "do_master_ssh_key" {
  name = var.do_master_ssh_pub_key_name
}

output "VM_IP_ADDR" {
  value = digitalocean_droplet.git_droplet.ipv4_address
}