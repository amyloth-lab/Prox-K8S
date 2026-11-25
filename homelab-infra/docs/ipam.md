# Network Design & IP Address Management (IPAM)

> **Documentation-only example:** Every address in this file uses the RFC 5737 TEST-NET-1 range (`192.0.2.0/24`). These values are reserved for documentation and must be replaced with a suitable private network before deployment.

## Network Overview

- **Example subnet CIDR:** `192.0.2.0/24`
- **Example subnet mask:** `255.255.255.0`
- **Example usable range:** `192.0.2.1`–`192.0.2.254`
- **Example gateway / DNS:** `192.0.2.1`
- **Example static range:** `192.0.2.100`–`192.0.2.199`

## Infrastructure & Node Allocation

| Hostname | Example IP address | Role | Proxmox host | vCPU | RAM | Disk |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `pve1` | `192.0.2.100` | Proxmox hypervisor 1 | Physical | - | - | - |
| `pve2` | `192.0.2.101` | Proxmox hypervisor 2 | Physical | - | - | - |
| `pve3` | `192.0.2.102` | Proxmox hypervisor 3 | Physical | - | - | - |
| **API VIP** | `192.0.2.150` | Kubernetes API virtual IP | Keepalived | - | - | - |
| **VIP pool** | `192.0.2.151`–`192.0.2.159` | Cilium LoadBalancer services (`.151` = ingress) | Cilium L2 | - | - | - |
| `k8s-lb-01` | `192.0.2.161` | HAProxy + Keepalived (primary) | `pve1` | 1 | 1 GB | 10 GB |
| `k8s-lb-02` | `192.0.2.162` | HAProxy + Keepalived (backup) | `pve2` | 1 | 1 GB | 10 GB |
| `k8s-cp-01` | `192.0.2.171` | Kubernetes control plane + etcd | `pve1` | 2 | 4 GB | 30 GB |
| `k8s-cp-02` | `192.0.2.172` | Kubernetes control plane + etcd | `pve2` | 2 | 4 GB | 30 GB |
| `k8s-cp-03` | `192.0.2.173` | Kubernetes control plane + etcd | `pve3` | 2 | 4 GB | 30 GB |
| `k8s-wk-01` | `192.0.2.181` | Kubernetes worker + Longhorn storage | `pve1` | 4 | 8 GB | 30 GB + 50 GB |
| `k8s-wk-02` | `192.0.2.182` | Kubernetes worker + Longhorn storage | `pve2` | 4 | 8 GB | 30 GB + 50 GB |
| `k8s-wk-03` | `192.0.2.183` | Kubernetes worker + Longhorn storage | `pve3` | 4 | 8 GB | 30 GB + 50 GB |

## Kubernetes Internal Networks

- **Pod CIDR:** `10.244.0.0/16` (managed by Cilium CNI)
- **Service CIDR:** `10.96.0.0/12` (internal ClusterIP services)
