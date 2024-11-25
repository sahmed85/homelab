# Deploying a Ubuntu VM with Terraform on Proxmox

This guide explains how to deploy a Ubunut Virtual Machine (VM) using Terraform on Proxmox. The example VM will have 2 CPUs, 2 GB of memory, and 30 GB of storage.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

- [Terraform](https://www.terraform.io/) installed on your local machine.
- A Proxmox server set up and accessible from your Terraform environment.
- An Ubuntu Server ISO image uploaded to your Proxmox server via the Proxmox Management GUI.

## Steps

1. Clone this repository or create your own Terraform configuration files.

2. Modify the `variables.tf` file to specify the `proxmox_user` and `proxmox_password` variables. These will be used to authenticate with your Proxmox server. You can also provide these variables when running the `terraform apply` command if you prefer not to hardcode them in your configuration.

3. Create a Proxmox VM using the following Terraform configuration:

```hcl
provider "proxmox" {
  pm_api_url  = "https://your-proxmox-server:8006/api2/json"
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  name   = "ubuntu-server-vm"
  target_node = "your-target-node"  # Replace with your Proxmox node name
  os_type = "l26"
  storage = "your-storage-pool"  # Replace with your storage pool name

  cores  = 2
  sockets = 1
  memory = 2048

  cdrom_image = "local:iso/ubuntu-server.iso"  # Adjust the path to your ISO

  disk {
    id     = 0
    storage = "your-storage-pool"
    size   = "30G"
    type   = "virtio"
  }

  network {
    id     = "net0"
    model  = "virtio"
    bridge = "vmbr0"  # Replace with your bridge name
  }
}
```

Be sure to replace the placeholder values with your specific configuration details.

4. Initialize your Terraform workspace by running:

```bash
terraform init

terraform init \
-backend-config="bucket=${TFSTATE_BUCKET}" \
-backend-config="key=${TFSTATE_KEY}" \
-backend-config="region=${TFSTATE_REGION}" 
```

5. Plan the changes by running:

```bash
terraform plan -var="proxmox_user=myuser" -var="proxmox_password=mypassword"
```

6. If the plan looks correct, apply the configuration to create the VM:

```bash
terraform apply -var="proxmox_user=myuser" -var="proxmox_password=mypassword"
```

7. Terraform will prompt you to confirm the action. Type "yes" and press Enter to proceed.

8. Terraform will create the VM on your Proxmox server. Once the process is complete, you will receive a message with the details of the newly created VM.

## Cleaning Up

To destroy the VM and associated resources, you can run:

```bash
terraform destroy -var="proxmox_user=myuser" -var="proxmox_password=mypassword"
```

Confirm the action by typing "yes" when prompted.

## Note

- **Security**: Ensure that you handle sensitive information, such as passwords, securely. Avoid hardcoding them directly in your Terraform configuration files. Consider using environment variables or external secrets management tools.

- **Customization**: The provided Terraform configuration is a basic example. You can customize it further to meet your specific requirements, such as adjusting resource specifications, networking, or other configurations.

- **Proxmox Configuration**: Make sure your Proxmox server is properly configured, and you have the necessary permissions to create VMs.

- **Troubleshooting**: If you encounter any issues or errors, refer to Terraform and Proxmox documentation for troubleshooting tips and solutions.

Happy Terraforming! 🚀
