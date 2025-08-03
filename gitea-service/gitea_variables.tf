variable "do_token" {
  type        = string
  description = "API token for deployment of DigitalOcean resources. Keep this secret!"
}

variable "do_domain" {
  type        = string
  description = "Domain name to be used e.g. example.com. The final domain name will be gitea.example.com in this case"
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