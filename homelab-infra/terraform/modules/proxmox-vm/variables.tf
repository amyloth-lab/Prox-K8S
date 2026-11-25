variable "vm_id" {
  description = "Unique Proxmox VM ID"
  type        = number
}

variable "name" {
  description = "VM hostname"
  type        = string
}

variable "target_node" {
  description = "Proxmox node name (pve1, pve2, or pve3)"
  type        = string
}

variable "template_id" {
  description = "Cloud-Init template VM ID on the target Proxmox node"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "RAM in MB"
  type        = number
}

variable "os_disk_size" {
  description = "Primary OS disk size in GB"
  type        = number
}

variable "data_disk_size" {
  description = "Optional secondary disk size in GB for Longhorn storage (0 = disabled)"
  type        = number
  default     = 0
}

variable "storage_pool" {
  description = "Proxmox storage pool name (e.g., local-lvm)"
  type        = string
}

variable "network_bridge" {
  description = "Proxmox network bridge (e.g., vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "ip_cidr" {
  description = "Static IPv4 address with CIDR prefix (e.g., 192.0.2.171/24; documentation-only example)"
  type        = string
}

variable "gateway" {
  description = "Default IPv4 gateway"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
}

variable "ci_user" {
  description = "Default sudo user created by Cloud-Init"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key injected into authorized_keys"
  type        = string
}

variable "tags" {
  description = "List of Proxmox UI tags for filtering and organization"
  type        = list(string)
  default     = []
}
