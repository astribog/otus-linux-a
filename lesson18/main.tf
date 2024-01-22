terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=1.0.0"
    }
  }
  required_version = ">= 0.14"
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.56.10:8006/api2/json"
    pm_password = "vagrant"
    pm_user = "root@pam"
    pm_otp = ""
}

resource "proxmox_lxc" "lxc-test" {
    features {
        nesting = true
    }
    hostname = "terraform-new-container"
    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.56.20/24"
        ip6 = "dhcp"
    }
    ostemplate = "local:vztmpl/ubuntu-23.04-standard_23.04-1_amd64.tar.zst"
    password = "rootroot"
#    pool = "terraform"
    target_node = "pve"
    unprivileged = true
    rootfs {
    storage = "local-lvm"
    size    = "8G"
  }
}