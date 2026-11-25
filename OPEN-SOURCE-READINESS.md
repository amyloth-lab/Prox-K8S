# Open-Source Readiness

## Status

**Improved, but not fully ready for public release yet.** The current working tree has a license and repository-level ignores, and the published network documentation uses documentation-only addresses. A maintainer still needs to enable a private vulnerability-reporting channel and complete the checks below. No Git commits existed at the time of this review, so prior history could not be audited.

## Changes made for publication

- Added the MIT License. Copyright notice: `Prox-K8S contributors`, 2026.
- Added root ignore rules for Terraform state/plans, local variable files, credentials, kubeconfigs, and local Ansible files.
- Kept Terraform provider lockfiles eligible for version control by removing the nested ignore rule for `.terraform.lock.hcl`.
- Replaced the specific LAN IP topology in documentation with RFC 5737 documentation-only example addresses.
- Corrected stale security/readiness notes that referred to state, plan, or secret files not present in the current working tree.

## Required before public release

### Maintainer action

- Enable GitHub private vulnerability reporting, or add another verified private contact method to `SECURITY.md`.
- Choose whether to publish a code of conduct, issue templates, and pull-request templates.

### Final repository checks

- Run a dedicated secret scanner against the files to be published and, once commits exist, the full Git history.
- Review the staged file list and staged diff. In particular, confirm no local Terraform state/plan, `.terraform` cache, real inventory, Vault data, kubeconfig, private key, or plaintext secret is included.
- Confirm copyright ownership and third-party license obligations for material being published under the MIT License.
- Replace all example domains, repository URLs, network values, Proxmox node/template IDs, and other environment values before deployment.

### Operational readiness (not required to license the source)

- Document provider authentication, VM template requirements, Ansible collection versions, and complete Cilium/Argo CD bootstrap and teardown steps.
- Add reproducible CI checks and secret scanning.
- Document access controls and harden reachable monitoring endpoints, image/dependency integrity, RBAC, backup/restore, and admission policy.
- Replace or explicitly retain the currently empty Jenkinsfile.

## Scope and evidence

This is a worktree review, not a deployment audit. The presence of configuration in this repository does not establish how a live cluster is exposed or secured. Ignored local files and Git history must be checked separately before publication.
