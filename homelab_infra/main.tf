terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

# proxmox server connection
provider "proxmox" {
  pm_api_url  = "https://10.0.0.176:8006/api2/json"
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
}

# vm1 hosting rancher
resource "proxmox_vm_qemu" "k8s_cluster_vm1" {
  vmid        = 201
  name        = "homelab-k8s-cluster-vm1"
  target_node = "homelab"
  clone       = "ubuntu-jammy-template" # custom template that I created
  full_clone  = true

  # Define the VM resources
  # Define the VirtIO SCSI controller
  scsihw    = "virtio-scsi-pci"
  ciuser    = "shada"
  ipconfig0 = "ip=dhcp"
  qemu_os   = "other"

  cores   = 2
  sockets = 1
  memory  = 4096 # 4 GB

  # Disk configuration
  disk {
    storage = "local-lvm" # Replace with your storage pool name
    size    = "50G"
    type    = "scsi"
  }

  # Network interface
  network {
    model    = "virtio"
    bridge   = "vmbr0" # Replace with your bridge name
    firewall = true
  }
}

# vm2 k8s cluster node
resource "proxmox_vm_qemu" "k8s_cluster_vm2" {
  vmid        = 202
  name        = "homelab-k8s-cluster-vm2"
  target_node = "homelab"
  clone       = "ubuntu-jammy-template" # custom template that I created
  full_clone  = true

  # Define the VM resources
  # Define the VirtIO SCSI controller
  scsihw    = "virtio-scsi-pci"
  ciuser    = "shada"
  ipconfig0 = "ip=dhcp"
  qemu_os   = "other"

  cores   = 2
  sockets = 1
  memory  = 4096 # 4 GB

  # Disk configuration
  disk {
    storage = "local-lvm" # Replace with your storage pool name
    size    = "50G"
    type    = "scsi"
  }

  # Network interface
  network {
    model    = "virtio"
    bridge   = "vmbr0" # Replace with your bridge name
    firewall = true
  }
}

# vm2 k8s cluster node
resource "proxmox_vm_qemu" "k8s_cluster_vm3" {
  vmid        = 203
  name        = "homelab-k8s-cluster-vm3"
  target_node = "homelab"
  clone       = "ubuntu-jammy-template" # custom template that I created
  full_clone  = true

  # Define the VM resources
  # Define the VirtIO SCSI controller
  scsihw    = "virtio-scsi-pci"
  ciuser    = "shada"
  ipconfig0 = "ip=dhcp"
  qemu_os   = "other"

  cores   = 2
  sockets = 1
  memory  = 4096 # 4 GB

  # Disk configuration
  disk {
    storage = "local-lvm" # Replace with your storage pool name
    size    = "50G"
    type    = "scsi"
  }

  # Network interface
  network {
    model    = "virtio"
    bridge   = "vmbr0" # Replace with your bridge name
    firewall = true
  }
}

# Output the VM's ID
output "k8s_cluster_vm1_output" {
  value = proxmox_vm_qemu.k8s_cluster_vm1.id
}

# Output the VM's ID
output "k8s_cluster_vm2_output" {
  value = proxmox_vm_qemu.k8s_cluster_vm2.id
}

# Output the VM's ID
output "k8s_cluster_vm3_output" {
  value = proxmox_vm_qemu.k8s_cluster_vm3.id
}

