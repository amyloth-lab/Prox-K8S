# Configuration and Secret Management

## Quick start

Do not copy secrets or private infrastructure data into Git. Use local variable files and environment-specific secret stores.

### Infrastructure variables

1. Copy `homelab-infra/terraform/environments/prod/terraform.tfvars.example` to `terraform.tfvars`.
2. Replace all `192.0.2.x` addresses, Proxmox node names, template IDs, storage names, and SSH key paths.
3. Keep `terraform.tfvars`, `.tfstate`, and `.tfplan` outside source control.
4. Copy `homelab-infra/ansible/inventories/prod/group_vars/all.yml.example` to a secure extra-vars or Ansible Vault file.
5. Copy `hosts.ini.example` to `hosts.ini` and replace example addresses and hostnames.

### Required infrastructure variables

| Variable | Purpose |
| --- | --- |
| `lab_api_vip` | Kubernetes API virtual IP |
| `lab_network_interface` | Node network interface |
| `lab_pod_cidr` | Kubernetes pod CIDR |
| `lab_service_cidr` | Kubernetes service CIDR |
| `kubernetes_version` | kubeadm/Kubernetes version |
| `storage_data_device` | Worker secondary disk device |
| `vault_vrrp_auth_pass` | Keepalived authentication secret |

`vault_vrrp_auth_pass` must be supplied by Ansible Vault or an approved secrets manager. It must not be added to `group_vars` or `hosts.ini`.

## SSH host verification

Host-key checking is enabled. Before running playbooks:

1. Obtain host fingerprints through an authenticated or out-of-band channel.
2. Add them to `~/.ssh/known_hosts`.
3. Confirm the SSH key path in `ansible.cfg`.

Do not set `host_key_checking = False`.

## GitOps variables

1. Copy `homelab-gitops/.env.example` to `.env.local`.
2. Replace every example repository, domain, IP, backup target, and public AGE recipient.
3. Run `pwsh -File homelab-gitops/scripts/render-environment.ps1 -EnvironmentFile .env.local`.
4. Confirm rendered YAML before committing or syncing.

`.env.local`, private keys, kubeconfigs, Vault files, and secret manifests are ignored and must remain outside Git.

## Grafana credentials

Provision `grafana-admin-credentials` separately in the `monitoring` namespace:

```powershell
kubectl -n monitoring create secret generic grafana-admin-credentials `
  --from-literal=admin-user='<generated-username>' `
  --from-literal=admin-password='<generated-password>'
```

Use a password manager or secret manager to generate and store the credential. Rotate it if repository or cluster access is exposed.

## AGE key

Generate or obtain an AGE key pair through the approved secret-management process. Put only the public recipient in the SOPS configuration. Store the private key in a protected location and mount it into Argo CD repo-server as `sops-age`.

Example setup is intentionally not included because it requires environment-specific key material.

## Verification

Before deploying:

- Run `terraform validate`.
- Run `ansible-playbook --syntax-check` for every playbook.
- Run `kubectl kustomize infrastructure/monitoring`.
- Review Git for private keys, kubeconfigs, state/plan files, passwords, API tokens, and private IPs.
