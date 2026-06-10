---
title: 'NixRMM'
summary: 'An enterprise-grade RMM scoped entirely to NixOS: one pane of glass, in-browser RDP/SSH, and atomic full-system config swaps with automatic rollback.'
status: 'in-development'
year: '2026'
stack: ['NixOS', 'Rust', 'SvelteKit', 'PostgreSQL', 'Guacamole']
featured: true
order: 2
---

Commercial RMMs are sprawling by design — agents that do everything, on
every OS, for every MSP workflow. **NixRMM** bets the other way: build to
NinjaOne/ConnectWise *quality* but deliberately *narrow* — NixOS machines
only, three capabilities, each done properly.

## Three verbs

- **See.** A single pane of glass over the fleet. The control plane pulls a
  snapshot from each host's agent every few minutes (and on demand): live
  metrics, systemd units with failures flagged, journald tail, and NixOS
  facts — current generation, active setup, last rebuild, and an exact
  drift flag for whether the host is running what it's supposed to.
- **Connect.** Click a host, get a clientless **RDP or SSH session in the
  browser**, brokered through Apache Guacamole on the control plane.
  Nothing to install on the operator's machine, and every session writes
  an audit entry: who, which host, when.
- **Swap.** The differentiator. Every managed machine's full system
  configuration — a "setup" — lives in one central catalog of
  `nixosConfigurations`. The operator picks a setup in the UI and applies
  it: the closure builds on the control plane, gets served from a binary
  cache, and the target pulls and activates it atomically.

## With the grain of NixOS

The core philosophy: NixOS is declarative and immutable, so management
should work *with* that grain. Patching and reconfiguration aren't
different workflows — both are "rebuild the machine to a known-good,
version-pinned target." Updating a host is just swapping it to a newer
build of its current setup, on the same engine. And because desired state
is a closure, drift detection is an equality check, not a heuristic scan.

## Never brick a host

Every swap and update runs with **magic-rollback semantics**: the new
generation activates, then must pass a health check within a timeout.
Failed activation, failed health check, or lost connectivity — the host
rolls back to the previous generation on its own. The operator is never
left with an unreachable machine; a deliberately broken setup surviving
this gauntlet is a release-blocking test, not a hope.

## Architecture

```text
                      ┌────────────────────────────────┐
 operator's browser ──│   control plane (NixOS host)   │
                      │  web UI · orchestrator/API     │
                      │  PostgreSQL (inventory, setup  │
                      │   catalog, audit, snapshots)   │
                      │  Guacamole broker (RDP/SSH)    │
                      │  Nix binary cache (closures)   │
                      └───────────────┬────────────────┘
                                      │  flat LAN / operator-supplied VPN
                     ┌────────────────┼────────────────┐
              ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
              │ NixOS host  │  │ NixOS host  │  │ NixOS host  │
              │ thin agent  │  │   agent     │  │   agent     │
              │ RDP + SSH   │  │ RDP + SSH   │  │ RDP + SSH   │
              └─────────────┘  └─────────────┘  └─────────────┘
```

The agent is a thin Rust static binary delivered as a NixOS module — it
serves one authenticated snapshot endpoint and stays out of the way.
The control plane (Rust, PostgreSQL) owns inventory, the setup catalog,
and the audit log; the UI is SvelteKit. Pull model, latest-snapshot-only:
no time-series history, by design. The control plane is itself a managed
NixOS host — the platform dogfoods its own module.

## Narrow on purpose

v1 explicitly does **not** include SIEM, log shipping or retention, CVE
scanning, multi-tenancy, ticketing, or alerting — and connectivity is
"bring your own VPN" rather than a built-in relay. Those are parked with
clean seams, not designed out. An RMM that does three things an operator
can trust beats one that does thirty things a vendor can demo.

One constraint runs through the whole build: **permissive licenses only**
in anything shipped (no GPL/AGPL/SSPL), enforced by an automated license
check in CI — it's part of why the UI is custom instead of wrapping
Grafana. The repo is a single flake (flake-parts), `nix flake check` stays
green at every commit, and decisions land as ADRs.

## Status

In active development, working toward the Phase 1 milestone: a 2–3 host
homelab fleet with snapshots flowing, in-browser RDP/SSH working, and a
demonstrated swap-with-auto-rollback — including the deliberately broken
setup that has to fail safely. The [homelab](/projects/homelab/) is the
proving ground; design notes grow in the
[thought garden](/garden/declarative-fleet-management/).
