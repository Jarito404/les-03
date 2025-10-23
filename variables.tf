variable "esxi_hostname" { default = "192.168.1.10"}
variable "esxi_hostport" { default = "443" }
variable "esxi_hostssl"  { default = true }
variable "esxi_username" { default = "root"}
variable "esxi_password" { default = "Welkom01!"}
variable "ssh_pub_key_path" {
  default = "~/.ssh/id_ed25519.pub"
}

