terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
##
provider "yandex" {
  zone = "ru-central1-a"
}
##
resource "yandex_compute_instance" "blnc1" {
  name = "b1nc1"
  hostname = "blnc1.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
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
resource "yandex_compute_instance" "nginx1" {
  name = "nginx1"
  hostname = "nginx1.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
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
resource "yandex_compute_instance" "nginx2" {
  name = "nginx2"
  hostname = "nginx2.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
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
resource "yandex_compute_instance" "sql1" {
  name = "sql1"
  hostname = "sql1.otus.lab"
#
  resources {
    cores  = 2
    memory = 2
  }
#
  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }
#
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.5"
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
    nginx_balancer:
      hosts:
        blnc1:
            ansible_host: "${yandex_compute_instance.blnc1.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
    nginx_backend:
        hosts:
          nginx1:
            ansible_host: "${yandex_compute_instance.nginx1.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
          nginx2:
            ansible_host: "${yandex_compute_instance.nginx2.network_interface.0.nat_ip_address}"
            ansible_private_key_file: "/home/user/.ssh/id_ed25519"
    sql_backend:
        hosts:
          sql1:
            ansible_host: "${yandex_compute_instance.sql1.network_interface.0.nat_ip_address}"
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