terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}


provider "proxmox" {
    pm_api_url = "https://10.0.0.176:8006/api2/json"
    pm_user     = var.proxmox_user
    pm_password = var.proxmox_password
}


resource "proxmox_vm_qemu" "vm_1" {
  name        = "homelab-vm-1"
  target_node = "homelab"
  iso         = "local:iso/ubuntu-server-22.04.3.iso"

  # Specifying the VM parameters
  os_type = "ubuntu"  # Ubuntu Server

  # Define the VM resources
  cores  = 2
  sockets = 1
  memory = 2048  # 2 GB

  # Disk configuration
  disk {
    storage = "local-lvm"  # Replace with your storage pool name
    size   = "30G"
    type   = "scsi"
  }

  # Network interface
  network {
    model  = "virtio"
    bridge = "vmbr0"  # Replace with your bridge name
    firewall = true
  }
}

# Output the VM's ID
output "vm_id" {
  value = proxmox_vm_qemu.vm_1.id
}
