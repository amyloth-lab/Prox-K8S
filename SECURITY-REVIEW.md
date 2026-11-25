# Security Review

## Scope and limitations

This review reflects the current working tree, not a deployed cluster or Git history. The repository had no commits at the time of review, so no prior history could be scanned. A text-pattern search found no obvious plaintext credential, but it is not a substitute for a dedicated secret scanner. Local ignored files are outside this review.

## Findings

| Severity | Evidence | Risk / action |
| --- | --- | --- |
| High before public release | `SECURITY.md` | Private vulnerability reporting is not confirmed as enabled. Enable GitHub private vulnerability reporting or add a verified private contact method before public release. |
| Medium | `homelab-gitops/infrastructure/argocd/values.yaml` | The repo-server init container downloads KSOPS and extracts it without checksum/signature verification, while the repo-server mounts the SOPS AGE key. Pin and verify the artifact before using this setup with sensitive keys. |
| Medium, deployment-dependent | `homelab-gitops/infrastructure/monitoring/loki-values.yaml` and `infrastructure/monitoring/httproutes.yaml` | Loki authentication is disabled and monitoring routes are configured. Restrict access at the gateway/network layer or configure authentication before exposing these routes beyond a trusted network. |
| Low | `homelab-gitops/infrastructure/argocd/values.yaml` | `server.insecure` is enabled. Confirm TLS termination and trusted ingress behavior for the actual deployment. |
| Low | `homelab-gitops/.sops.yaml` | The AGE recipient is an example placeholder. Replace it with an environment-specific public recipient; never commit the private AGE key. |
| Informational | Documentation and sample configuration | IPs, domains, and repository URLs are examples. Replace them before deployment; RFC 5737 addresses in IPAM documentation are not valid deployment targets. |

## Hygiene observed

- The root `.gitignore` excludes Terraform state, plans, generated `.terraform` directories, local `.tfvars`, kubeconfigs, private-key files, and local Ansible inventory/Vault files.
- The Terraform provider lockfile is no longer ignored and should be committed for reproducible provider selection.
- Ansible host-key checking is enabled in the checked-in `ansible.cfg`.
- The Keepalived password is referenced through `vault_vrrp_auth_pass`, not set to a literal in the checked-in load-balancer variables.
- No Terraform state, plan, private AGE key, or plaintext secret file appeared in the working-tree file listing during this review. A dedicated secret scan and staged-diff review are still required.

## Publication checklist

1. Enable the private reporting channel described in `SECURITY.md`.
2. Run a dedicated secret scanner on the exact publication set and on Git history once commits exist.
3. Check `git status --ignored`, the staged file list, and staged diff. Never publish local state, plans, caches, credentials, or deployment artifacts.
4. Reassess the gateway, monitoring exposure, Argo CD TLS, and KSOPS artifact integrity for the actual target environment.

The absence of a configuration file in this repository is not proof that a live cluster lacks a control.
