terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.122.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  vm_id       = var.vm_id
  name        = var.name
  node_name   = var.target_node
  tags        = var.tags
  started     = true
  on_boot     = true

  clone {
    vm_id = var.template_id
    full  = true
  }

  agent {
    enabled = true
    timeout = "2m"
  }

  cpu {
    cores = var.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
  }

  # Primary OS Disk
  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = var.os_disk_size
    iothread     = true
    discard      = "on"
  }

  # Optional Secondary Longhorn Storage Disk (Workers only)
  dynamic "disk" {
    for_each = var.data_disk_size > 0 ? [1] : []
    content {
      datastore_id = var.storage_pool
      interface    = "scsi1"
      size         = var.data_disk_size
      iothread     = true
      discard      = "on"
    }
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {
    datastore_id = var.storage_pool

    ip_config {
      ipv4 {
        address = var.ip_cidr
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      username = var.ci_user
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }
}