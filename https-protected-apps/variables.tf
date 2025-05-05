variable "bigip_address" {}
variable "bigip_username" {}
variable "bigip_password" {}
variable "bigip_applications" {
  type = list(object({
    name             = string
    fqdn             = string
    virtual_address  = string
    virtual_port     = number
    tls_termination  = string
    service_port     = number
    server_addresses = list(string)
  }))
}
