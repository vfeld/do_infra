resource "digitalocean_volume_attachment" "gitea_mount" {
  droplet_id = digitalocean_droplet.gitea_droplet.id
  volume_id  = data.digitalocean_volume.gitea_volume.id
}