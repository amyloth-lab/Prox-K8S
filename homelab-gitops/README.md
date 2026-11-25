# Homelab GitOps

This directory contains the Kubernetes platform configuration managed by Argo CD.

## Bootstrap

`bootstrap/root-app.yaml` is the app-of-apps entry point. It points to `bootstrap/apps`, whose Application manifests define Argo CD, cert-manager, Gateway, Longhorn, monitoring, Loki, Alloy, and Homepage applications.

The repository does not contain an Argo CD Application manifest for Cilium itself. Cilium values are present under `infrastructure/cilium`, but the bootstrap process that installs Cilium is missing.

## Platform components

| Component | Repository evidence |
| --- | --- |
| Cilium | CNI values, Gateway API, L2 IP pool, and L2 announcement policy |
| Gateway API | Shared Cilium Gateway with HTTP and HTTPS listeners |
| cert-manager | Self-signed bootstrap CA and a cluster issuer |
| Argo CD | Helm values, KSOPS integration, and HTTPRoute |
| Longhorn | Helm values, backup target, recurring job, and HTTPRoute |
| Monitoring | kube-prometheus-stack, Grafana credentials, Loki, Alloy, and HTTPRoutes |
| Homepage | Helm values and Gateway HTTPRoute discovery |

## Secret handling

SOPS configuration in `.sops.yaml` uses an AGE recipient for `*.enc.yaml` files. Argo CD repo-server configuration expects an AGE secret mounted at `/.config/sops/age/keys.txt`.

The private AGE key is not present in the repository snapshot. Do not add it. Configure the `sops-age` Kubernetes secret through an approved out-of-repository process.

## Environment rendering

Copy `.env.example` to `.env.local`, replace the placeholder values, and run:

```powershell
pwsh -File scripts/render-environment.ps1 -EnvironmentFile .env.local
```

The renderer updates only repository YAML under `bootstrap`, `infrastructure`, and `apps`. `.env.local` is ignored by Git.

## Required substitutions

Before publishing or cloning into another environment, review:

- Git SSH repository URLs
- `main` branch assumptions
- `example.com` hostnames
- documentation-only example network values (replace these with your own private LAN CIDRs)
- API, ingress, and load-balancer addresses
- the AGE recipient
- Grafana credentials
- chart and image versions
