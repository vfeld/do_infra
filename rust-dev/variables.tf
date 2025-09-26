variable "do_token" {
  type        = string
  description = "API token for deployment of DigitalOcean resources. Keep this secret!"
}

variable "do_ssh_pub_key_file" {
  type        = string
  description = "Path to a local ssh public key file"
}

variable "do_master_ssh_pub_key_name" {
  type        = string
  description = "SSH key name registered in digitalocean"
}

variable "do_admin_user" {
  type        = string
  description = "Name of the admin user to be created"
}

variable "do_domain" {
  type        = string
  description = "Domain name to be used e.g. example.com. The final domain name will be gitea.example.com in this case"
}

variable "do_droplet_name" {
  type        = string
  description = "Name of the droplet e.g. cluster1. The name will also determine the FQDN cluster1.example.com."
}

variable "do_region" {
  type        = string
  description = "Region to deploy to e.g. fra1"
}

variable "do_image" {
  description = "OS image to be used e.g. ubuntu-24-04-x64"
}

variable "do_droplet_size" {
    description = "Droplet slug specifying the configuration size e.g. s-1vcpu-1gb-amd"
}