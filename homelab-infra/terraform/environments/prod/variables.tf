variable "storage_pool" {
  description = "Proxmox storage pool for VM disks"
  type        = string
}

variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
}

variable "gateway" {
  description = "Default gateway IP"
  type        = string
}

variable "dns_servers" {
  description = "DNS server IPs"
  type        = list(string)
}

variable "ci_user" {
  description = "Default SSH/sudo username"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key on workstation"
  type        = string
}

variable "vms" {
  description = "Map of VMs to provision"
  type = map(object({
    vm_id          = number
    target_node    = string
    template_id    = number
    cores          = number
    memory         = number
    os_disk_size   = number
    data_disk_size = optional(number, 0)
    ip_cidr        = string
    tags           = list(string)
  }))
}