output "provisioned_vms" {
  description = "Summary of provisioned Kubernetes cluster VMs"
  value = {
    for name, vm in module.k8s_vms : name => {
      vm_id     = vm.vm_id
      node      = vm.node_name
      configured_ip = var.vms[name].ip_cidr
    }
  }
}