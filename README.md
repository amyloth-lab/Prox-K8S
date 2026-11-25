# Prox-K8S

Prox-K8S is a two-part home-lab repository for provisioning a highly available Kubernetes cluster on Proxmox and managing its platform workloads with Argo CD.

## Repository contents

| Directory | Purpose |
| --- | --- |
| [`homelab-infra/`](homelab-infra/) | Proxmox VM provisioning with Terraform, node configuration with Ansible, and kubeadm cluster bootstrap |
| [`homelab-gitops/`](homelab-gitops/) | Argo CD applications, Helm values, Kustomize resources, SOPS/KSOPS decryption configuration, and Kubernetes platform manifests |

## Confirmed architecture

- Three Proxmox hypervisors
- Two HAProxy/Keepalived load-balancer VMs
- Three Kubernetes control-plane nodes
- Three Kubernetes worker nodes, each with a dedicated Longhorn data disk
- Pod CIDR: `10.244.0.0/16`
- Service CIDR: `10.96.0.0/12`
- Cilium CNI replaces kube-proxy
- Gateway API serves platform HTTP(S) routes
- Argo CD watches `bootstrap/apps` and creates the platform applications
- SOPS/KSOPS decrypts the encrypted Grafana credentials for Argo CD

See [`homelab-infra/docs/architecture.md`](homelab-infra/docs/architecture.md) and [`homelab-infra/docs/ipam.md`](homelab-infra/docs/ipam.md) for the existing network documentation.

## Deployment sequence

1. Supply Proxmox access through the BPG Proxmox provider and prepare the SSH key/template IDs.
2. Run Terraform in `homelab-infra/terraform/environments/prod`.
3. Run the Ansible playbooks against `homelab-infra/ansible/inventories/prod/hosts.ini`, in order:
   - `01-base-hardening.yml`
   - `02-loadbalancers.yml`
   - `03-k8s-prereqs.yml`
   - `04-k8s-bootstrap.yml`
4. Install Cilium before or during cluster bootstrap as the repository configuration requires; this repository does not contain an Argo CD application manifest for Cilium.
5. Install Argo CD and the SOPS/AGE decryption secret by the repository's documented/administrative process.
6. Apply `homelab-gitops/bootstrap/root-app.yaml`.
7. Argo CD synchronizes the applications under `homelab-gitops/bootstrap/apps`.

The repository snapshot does not include a single automated bootstrap script or CI pipeline that performs this entire sequence. Jenkinsfile and the exact Cilium installation command are missing from the evidenced workflow.

## Prerequisites

The implementation directly references or expects:

- Proxmox VE 3-node environment
- Terraform `>= 1.6.0`
- BPG Proxmox provider `0.122.0`
- An Ubuntu SSH user and matching public key
- Ubuntu VM templates identified by the IDs in `terraform.tfvars`
- Ansible collections for `posix`, `general`, and any collection modules used by the playbooks
- Kubernetes 1.31 packages
- Containerd
- Cilium
- Argo CD
- SOPS and KSOPS
- An AGE key secret named `sops-age`
- A DNS zone and certificates if the example `*.example.com` hostnames are used

Commands and exact collection requirements have not been consolidated in repository documentation.

## Public-release status

This repository is an example, not a turnkey deployment. Replace environment-specific values and complete the remaining release checks in [`OPEN-SOURCE-READINESS.md`](OPEN-SOURCE-READINESS.md) before publishing or deploying it.

The repository is licensed under the [MIT License](LICENSE). Do not use production credentials or deploy directly from the example configuration. Terraform state and plan files are local artifacts and must not be committed.

See [`docs/CONFIGURATION.md`](docs/CONFIGURATION.md) for variable-file and secret-provisioning procedures.
