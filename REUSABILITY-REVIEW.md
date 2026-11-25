# Reusability Review

## Portability constraints

| Area | Evidence | Limit | Recommended improvement |
| --- | --- | --- | --- |
| Proxmox nodes | `terraform.tfvars` uses `pve1`, `pve2`, `pve3` and VM/template IDs | Fork requires matching physical node names and template IDs | Parameterize nodes, VM IDs, templates, storage, and bridge per environment |
| Network | IPAM documentation uses RFC 5737 documentation-only example addresses; deployment values must be supplied per environment | Example addresses are not deployable and CIDR compatibility must be checked | Replace examples with a private LAN range and validate for overlap before deployment |
| Kubernetes | VIP and pod/service CIDRs are fixed | Conflicts with other cluster networks | Parameterize values and validate uniqueness in preflight checks |
| Domains | `example.com` appears across ingress routes and app links | Fork must edit multiple files | Use environment overlays or Helm values and publish a documented hostname variable |
| Argo CD repositories | Application manifests pin a GitHub SSH URL | Forks cannot synchronize until every manifest is changed | Parameterize repository URL and credentials; document separate bootstrap and workload repositories |
| SOPS AGE recipient | `.sops.yaml` pins one public recipient | Forks and maintainers require new keys | Provide setup scripts and a sample recipient; never commit private keys |
| SSH | Ansible defaults to `~/.ssh/id_ed25519`; host-key checking is enabled | Operators must provide the matching key and trusted host fingerprints | Configure the trusted key path and provision known-host entries through a trusted channel |
| Longhorn disk | `/dev/sdb` and VM data disk 50 GB are fixed | Hardware naming/layout varies | Parameterize device discovery and disk size; add preflight disk checks |
| Kubernetes version | Package and template versions are pinned | Upgrade paths require coordinated edits | Centralize supported versions and add upgrade documentation |

## Reusable components

The following components already show good separation:

- Terraform `proxmox-vm` module
- Environment `tfvars` for VM inventory
- Ansible inventory plus group variables
- Argo CD app-of-apps bootstrap
- Helm values separated from application manifests
- Kustomize resources for monitoring
- Cilium IP pool and gateway manifests separated from app manifests

## Parameterization priorities

1. Centralize environment values: domains, LAN CIDR, VIPs, node names, storage, DNS, and SSH identity.
2. Replace fork-specific repository URLs.
3. Add environment overlays for at least example, development, and production values.
4. Separate cluster bootstrap from platform application deployment.
5. Add validation for mutually dependent values, including template IDs and CIDR overlap.
6. Document every external prerequisite and generated secret.
