---
title: 'The Homelab'
summary: 'A fully declarative NixOS fleet at home: every host rebuildable from one repo, monitored, backed up, and used as the proving ground for everything else.'
status: 'active'
year: '2023 — ongoing'
stack: ['NixOS', 'Prometheus', 'Grafana', 'WireGuard', 'ZFS']
featured: false
order: 4
---

<!-- TODO(briggs): fluff — swap in your actual homelab topology and services. -->

Every host in the lab — router duties, storage, build machines, game-server
sandboxes — is defined in a single Nix flake. If a machine dies, recovery is
`nixos-install` plus a hostname, not an afternoon of archaeology.

## What it proves

- **Configuration is the documentation.** There is no wiki page that can
  drift from reality, because reality is generated from the repo.
- **Observability at home-scale.** Prometheus scrapes everything; Grafana
  dashboards and alerting mean the lab pages me before family members do.
- **Real constraints.** Backups (ZFS snapshots shipped offsite), secret
  management, and WireGuard-only remote access — practiced where the blast
  radius is my own evening, so they're reflexes where it counts.

The lab is also the dogfood pen for [Hearthwatch](/projects/hearthwatch/):
every design decision in the RMM gets tested against this fleet first.
