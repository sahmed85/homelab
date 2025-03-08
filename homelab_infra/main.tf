terraform {
  # pass backend s3 through terraform flags
  backend "s3" {

  }

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

# vm 1
resource "proxmox_vm_qemu" "nebula_server" {
  vmid        = 201
  name        = "nebula-server"
  target_node = "homelab"
  clone       = "ubuntu-jammy-template" # custom template that I created
  full_clone  = true
  onboot = true
  # Define the VM resources
  # Define the VirtIO SCSI controller
  scsihw    = "virtio-scsi-pci"
  ciuser    = "shada"
  ipconfig0 = "ip=10.0.0.177/24,gw=10.0.0.1"
  qemu_os   = "other"

  cores   = 4
  sockets = 1
  memory  = 7168 # 7 GB

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
    macaddr = "b4:b6:19:2b:2a:52" # random gen MAC Add added for DHCP Reservation
    firewall = true
  }
}

# vm 2
resource "proxmox_vm_qemu" "aurora_server" {
  vmid        = 202
  name        = "aurora-server"
  target_node = "homelab"
  clone       = "ubuntu-jammy-template" # custom template that I created
  full_clone  = true
  onboot      = true
  # Define the VM resources
  # Define the VirtIO SCSI controller
  scsihw    = "virtio-scsi-pci"
  ciuser    = "shada"
  ipconfig0 = "ip=10.0.0.178/24,gw=10.0.0.1"
  qemu_os   = "other"

  cores   = 4
  sockets = 1
  memory  = 7168 # 7 GB

  # Disk configuration
  disk {
    storage = "local-lvm" # Replace with your storage pool name
    size    = "50G"
    type    = "scsi"
  }

  # Network interface
  network {
    model    = "virtio"
    bridge   = "vmbr0"             # Replace with your bridge name
    macaddr  = "14:19:10:2b:96:fa" # random gen MAC Add added for DHCP Reservation
    firewall = true
  }
}



# # Output the VM's ID
# output "nebula_server_output" {
#   value = proxmox_vm_qemu.nebula_server.id
# }

# Output the VM's ID
output "aurora_server_output" {
  value = proxmox_vm_qemu.aurora_server.id
}

# # Output the VM's ID
# output "k8s_cluster_vm3_output" {
#   value = proxmox_vm_qemu.k8s_cluster_vm3.id
# }

