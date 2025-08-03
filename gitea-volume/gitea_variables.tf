variable "do_token" {
  type        = string
  description = "API token for deployment of DigitalOcean resources. Keep this secret!"
}

variable "do_region" {
  type        = string
  description = "Region to deploy to e.g. fra1"
}