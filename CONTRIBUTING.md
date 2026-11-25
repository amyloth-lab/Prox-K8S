# Contributing

## Scope

Changes to infrastructure and deployment configuration affect live systems. Documentation and code/configuration reviews should remain separate when evaluating a proposed change.

## Before contributing

- Review the repository architecture and deployment documentation.
- Keep environment-specific values in the appropriate variable or values file.
- Do not commit credentials, kubeconfigs, private keys, Terraform state, Terraform plans, or unencrypted secret material.
- Do not use real internal hostnames or private addresses in examples unless they are intentional placeholders.
- Verify changes against the smallest relevant environment.

## Validation

Available repository automation is incomplete: the checked-in Jenkinsfile is empty. Contributors should use the following evidence-based checks where applicable:

```text
terraform fmt -check
terraform validate
terraform plan
ansible-playbook --syntax-check
ansible-lint
kubeconform -strict -summary
kustomize build
kubectl apply --dry-run=server
```

Do not run `terraform apply`, Ansible playbooks, or Kubernetes mutations merely to validate documentation.

## Pull requests

Describe:

- The problem and affected components
- Expected behavior
- Validation performed
- Any environment assumptions
- Rollback or recovery considerations
- Whether infrastructure/configuration files require explicit approval before application
