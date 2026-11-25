# Production-Style Kubernetes Home Lab

High-availability Kubernetes cluster on a 3-node Proxmox VE cluster, provisioned with Terraform, configured with Ansible, and managed via Argo CD GitOps. Network and host details in the documentation are sanitized examples; replace them for your environment.

## Repository Layout
* `docs/` — Network IPAM tables, architecture diagrams, and operational runbooks.
* `terraform/` — Modular Proxmox VM provisioning (`modules/proxmox-vm`) and environment definitions (`environments/prod`).
* `ansible/` — Idempotent OS hardening, HAProxy/Keepalived setup, and `kubeadm` cluster bootstrap playbooks.
* `Jenkinsfile` — Automated validation pipeline (`terraform validate`, `ansible-lint`, `kubeconform`).

## Deployment workflow

The repository contains the following evidenced sequence:

1. `terraform/environments/prod` provisions eight VMs through `modules/proxmox-vm`.
2. The Ansible inventory targets two load balancers, three control-plane nodes, and three workers.
3. Playbooks run in numbered order: base hardening, load-balancer services, Kubernetes prerequisites, and kubeadm bootstrap.
4. The bootstrap initializes `k8s-cp-01`, joins the two secondary control-plane nodes, and joins the workers.
5. Cilium configuration and the Argo CD applications are maintained in the sibling `homelab-gitops` repository.

The checked-in `Jenkinsfile` is currently empty. It does not implement the pipeline described in the repository layout comment.

## Local prerequisites

- Terraform `>= 1.6.0`
- BPG Proxmox provider `0.122.0`
- Ansible with the modules referenced by the playbooks
- SSH access to Ubuntu nodes
- A public SSH key matching the Terraform `ssh_public_key_path`
- VM templates matching the configured template IDs
- Storage and network values matching the Proxmox environment

## Required review before changes

Terraform state and plan files are generated, environment-specific artifacts. Keep them out of source control. Terraform changes, Ansible changes, and VM or cluster operations require an impact assessment and explicit approval.
