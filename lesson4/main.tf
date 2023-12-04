terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
##
resource "yandex_compute_disk" "empty-disk" {
  name       = "tgt-disk"
  type       = "network-hdd"
  zone       = "ru-central1-a"
  size       = 1
  block_size = 4096
}
##
provider "yandex" {
  zone = "ru-central1-a"
}
##
resource "yandex_compute_instance" "tgt1" {
  name = "tgt1"
  hostname = "tgt1.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8b88l2b5mnj352lkdk"
    }
  }
#
  secondary_disk {
    disk_id = "${yandex_compute_disk.empty-disk.id}"
  }
#
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.10"
  }
#
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
##
resource "yandex_compute_instance" "pcs1" {
  name = "pcs1"
  hostname = "pcs1.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8b88l2b5mnj352lkdk"
    }
  }
#
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.11"
  }
#
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
##
resource "yandex_compute_instance" "pcs2" {
  name = "pcs2"
  hostname = "pcs2.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8b88l2b5mnj352lkdk"
    }
  }
#
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.12"
  }
#
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
##
resource "yandex_compute_instance" "pcs3" {
  name = "pcs3"
  hostname = "pcs3.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8b88l2b5mnj352lkdk"
    }
  }
#
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.13"
  }
#
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}
##
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
##
resource "local_file" "inventory" {
  filename = "./hosts.yml"
  content = <<EOF
---
all:
  children:
    target_server:
      hosts:
        tgt1:
            ansible_host: "${yandex_compute_instance.tgt1.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
    pcs_servers:
        hosts:
          pcs1:
            ansible_host: "${yandex_compute_instance.pcs1.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
          pcs2:
            ansible_host: "${yandex_compute_instance.pcs2.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
          pcs3:
            ansible_host: "${yandex_compute_instance.pcs3.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
  vars:
    domain: "otus.lab"
    ntp_timezone: "UTC"
    pcs_password: "strong_pass" # cluster user: hacluster
    cluster_name: "hacluster"
  EOF 
}
  
#output "internal_ip_address_vm_1" {
#  value = yandex_compute_instance.tgt1.network_interface.0.ip_address
#}

#output "external_ip_address_vm_1" {
#  value = yandex_compute_instance.tgt1.network_interface.0.nat_ip_address
#}