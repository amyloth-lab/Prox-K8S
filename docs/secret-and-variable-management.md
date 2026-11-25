# Secret and Variable Management

## Terraform

Create a local `terraform.tfvars` from `terraform/environments/prod/terraform.tfvars.example`. The local file is ignored and must not be committed. Store Terraform state in an approved remote backend with encryption and access controls.

## Ansible

Copy `ansible/inventories/prod/group_vars/all.yml.example` to a secure environment-specific extra-vars or Vault file. Store `vault_vrrp_auth_pass` outside Git with Ansible Vault.

Provision SSH host fingerprints before enabling Ansible host-key checking. The default SSH key path is `~/.ssh/id_ed25519`; configure `private_key_file` only through the operator's trusted Ansible environment.

## GitOps

Copy `.env.example` to `.env.local` and run `scripts/render-environment.ps1` only after reviewing all replacement values. Never commit `.env.local`.

Create the Grafana Secret separately as `grafana-admin-credentials` in the `monitoring` namespace. Use generated credentials and an approved secret-management process. Do not put plaintext credentials in Helm values or tracked YAML.

The SOPS `age` public recipient is a public key, but it must be replaced by an environment-specific recipient and the private key must remain outside Git. Configure the `sops-age` Kubernetes Secret and restrict access to the Argo CD repo-server.
