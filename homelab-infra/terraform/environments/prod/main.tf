module "k8s_vms" {
  source   = "../../modules/proxmox-vm"
  for_each = var.vms

  vm_id          = each.value.vm_id
  name           = each.key
  target_node    = each.value.target_node
  template_id    = each.value.template_id
  cores          = each.value.cores
  memory         = each.value.memory
  os_disk_size   = each.value.os_disk_size
  data_disk_size = each.value.data_disk_size
  storage_pool   = var.storage_pool
  network_bridge = var.network_bridge
  ip_cidr        = each.value.ip_cidr
  gateway        = var.gateway
  dns_servers    = var.dns_servers
  ci_user        = var.ci_user
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
  tags           = each.value.tags
}