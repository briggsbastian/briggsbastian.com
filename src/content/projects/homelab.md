---
title: 'The Homelab'
summary: 'A fully declarative NixOS fleet at home: every host rebuildable from one repo, monitored, backed up, and used as the proving ground for everything else.'
status: 'active'
year: '2023 — ongoing'
stack: ['NixOS', 'Prometheus', 'Grafana', 'WireGuard', 'ZFS']
featured: false
order: 4
---

<!-- TODO(briggs): the topology, hostnames, and VLAN scheme below are a
     plausible mock — swap in your actual hosts and addressing. -->

Every host in the lab — routing, storage, builds, monitoring, game-server
sandboxes — is defined in a single Nix flake. If a machine dies, recovery is
`nixos-install` plus a hostname, not an afternoon of archaeology.

## Base topology

```text
                         ISP
                          │
                  ┌───────┴────────┐
                  │    bonfire     │  NixOS router/firewall
                  │ nftables · DNS │  WireGuard endpoint (only way in)
                  └───────┬────────┘
                          │ trunk
                  ┌───────┴────────┐
                  │  L2 switch     │  VLAN segmentation
                  └─┬────┬────┬──┬─┘
        ────────────┘    │    │  └─────────────
        │                │    │               │
   VLAN 10 mgmt     VLAN 20 lan   VLAN 30 lab    VLAN 40 iot
   switch/IPMI      trusted       the fleet      untrusted, no
   admin only       clients       (below)        east-west traffic
```

The lab VLAN is where the fleet lives:

| Host         | Role                                                        |
| ------------ | ----------------------------------------------------------- |
| `bonfire`    | Router, firewall (nftables), DNS, WireGuard concentrator    |
| `vault`      | ZFS storage — datasets for backups, media, build artifacts  |
| `forge`      | Build host — Nix remote builder, CI runners, OCI registry   |
| `watchtower` | Prometheus, Grafana, Alertmanager, log aggregation          |
| `arena`      | Game-server sandbox — where Gesture dedicated builds land   |

Segmentation rules are the interesting part: IoT can reach the internet
and nothing else, the lab VLAN accepts management traffic only from
`mgmt`, and every inter-VLAN rule is an nftables entry in the flake —
reviewed in a diff like everything else.

## What it proves

- **Configuration is the documentation.** There is no wiki page that can
  drift from reality, because reality is generated from the repo.
- **Observability at home-scale.** Prometheus scrapes everything; Grafana
  dashboards and alerting mean the lab pages me before family members do.
- **Real constraints.** Backups (ZFS snapshots shipped offsite), secret
  management, and WireGuard-only remote access — practiced where the blast
  radius is my own evening, so they're reflexes where it counts.

The lab is also the dogfood pen for [NixRMM](/projects/nixrmm/): every
design decision in the RMM gets tested against this fleet first, and
`arena` keeps [Gesture](/projects/gesture/)'s server builds honest.
