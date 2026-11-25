# Deployment Workflow

This document reconstructs the workflow directly supported by repository files. It does not represent an automated process unless a separate script or CI system provides it.

## Phase 1: Proxmox VM provisioning

Terraform root module:

```text
homelab-infra/terraform/environments/prod
  -> module ../../modules/proxmox-vm
  -> BPG Proxmox provider
  -> VM resources
```

The environment provisions:

- 2 load-balancer VMs
- 3 control-plane VMs
- 3 worker VMs
- 50 GB secondary disks for each worker

Provider authentication is not documented as a file. The provider uses SSH agent authentication.

## Phase 2: Operating-system configuration

Ansible inventory:

```text
loadbalancers
control_plane
workers
control_plane + workers = k8s_cluster
```

Run the numbered playbooks:

1. `01-base-hardening.yml`: timezone, packages, Chrony, SSH hardening
2. `02-loadbalancers.yml`: HAProxy and Keepalived
3. `03-k8s-prereqs.yml`: swap, kernel modules, sysctls, containerd, Kubernetes packages, Longhorn prerequisites
4. `04-k8s-bootstrap.yml`: kubeadm initialization and joins

## Phase 3: Kubernetes bootstrap

The primary control-plane play initializes `k8s-cp-01` with:

- an environment-specific virtual IP and port `6443` as the control-plane endpoint (the checked-in IPAM documentation uses documentation-only example addresses)
- Pod CIDR `10.244.0.0/16`
- Service CIDR `10.96.0.0/12`
- kube-proxy disabled in kubeadm phases
- Cilium as the expected CNI

It generates control-plane and worker join commands, joins secondary control-plane nodes serially, joins workers, and labels workers.

## Phase 4: Platform installation

No repository script proves the installation order for Cilium or Argo CD. The Cilium values and Argo CD values exist and must be reconciled with cluster bootstrap by the operator.

After Argo CD is installed, apply:

```text
homelab-gitops/bootstrap/root-app.yaml
```

The root Application points to `homelab-gitops/bootstrap/apps`. Each child Application uses automated prune and self-heal.

## Phase 5: Platform reconciliation

Argo CD manages:

- certificate issuer and root CA
- Cilium Gateway configuration
- Longhorn
- Prometheus, Alertmanager, Grafana
- Loki and Alloy
- Homepage
- HTTPRoutes

The SOPS/KSOPS repo-server setup is responsible for decrypting the Grafana secret.

## Validation gaps

The repository does not prove the following:

- Exact Cilium installation command or Helm release
- Argo CD initial installation command
- `SOPS_AGE_KEY_FILE` secret creation
- DNS creation for public/private hostnames
- root certificate trust distribution
- Longhorn backup destination credentials
- Jenkins pipeline behavior
- rollback or disaster recovery procedures
