terraform {
  required_version = ">= 1.3.0"
  required_providers {
    esxi = {
      source  = "registry.terraform.io/josenk/esxi"
    }
  }
}

provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

resource "esxi_guest" "demoapp" {
  guest_name = "demoapp"
  disk_store = "datastore1"
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "15"

  memsize            = "2048"
  numvcpus           = "1"
  power              = "on"

  clone_from_vm = "base-ubuntu"

  network_interfaces {
    virtual_network = "VM Network"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30
}

# SSH key toevoegen
locals {
  pubkey_raw = trimspace(file(var.ssh_pub_key_path))
  cloudinit  = replace(file("${path.module}/cloudinit.yml"), "PLACEHOLDER_PUBKEY", local.pubkey_raw)
}

# Genereer automatisch inventory
data "template_file" "ansible_inventory" {
  template = file("${path.module}/inventory.tpl")
  vars = {
    vm_ip    = esxi_guest.demoapp.ip_address
    app_name = "demoapp"
  }
}

resource "local_file" "inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/inventory.ini"
}

output "vm_ip" {
  value = esxi_guest.demoapp.ip_address
}

