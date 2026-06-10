---
title: 'NixRMM'
summary: 'A scoped RMM built NixOS-first. Declarative fleet management with least-privilege agents — remote monitoring without handing out remote shells.'
status: 'in-development'
year: '2026'
stack: ['NixOS', 'Go', 'Nix Modules', 'gRPC']
featured: true
order: 2
---

<!-- TODO(briggs): the architecture below is a plausible sketch — replace
     with the real design as it solidifies. -->

Traditional RMM tools are a standing contradiction: you install a
root-privileged remote-execution agent on every machine you manage, then
spend the rest of your career hoping it never gets popped. **NixRMM**
starts from the other end — what does fleet management look like when the
fleet is NixOS and the agent is allowed to do *almost nothing*?

## The premise

- **Declarative first.** On NixOS, "remediation" shouldn't mean a tech
  running ad-hoc shell commands. It means a config change, reviewed and
  rolled out — and rolled *back* — atomically. NixRMM treats the Nix
  configuration as the management plane.
- **Scoped by design.** The agent exposes a small, typed set of operations
  instead of a remote shell. Every capability is granted per-host,
  per-operator, and logged.
- **Drift is a bug report.** Because the desired state is a Nix closure,
  drift detection is exact, not heuristic. The dashboard answers "which
  hosts are not running what the repo says" with a hash comparison.

## Architecture

```text
        ┌───────────────────────────────┐
        │         control plane         │
        │   fleet state · audit log     │
        │   signing · operator RBAC     │
        └──────┬───────────────▲────────┘
   signed gens │               │ state reports,
   + verbs     │               │ drift hashes
        ┌──────▼───────────────┴────────┐
        │        agent (per host)       │
        │   a verifier, not executor:   │
        │   · report closure hash       │
        │   · apply signed generation   │
        │   · restart allowlisted unit  │
        │   · collect health metrics    │
        └───────────────────────────────┘
```

Three deliberate constraints shape everything:

1. **The agent has no general execution path.** Its gRPC surface is a
   handful of typed verbs. There is no "run script" verb, and adding one
   would be a fork, not a config flag.
2. **Generations are signed at the control plane.** A compromised agent
   can lie about its own host; it cannot push configuration anywhere else.
   A stolen operator session still can't ship a generation that wasn't
   built from the reviewed repo.
3. **Every operator action is an audit event first.** The log isn't a
   compliance afterthought bolted on the side — actions are *written as*
   audit entries and executed from the log. If it didn't get logged, it
   never got the chance to happen.

## The capability model

Permissions attach to (operator, host group, verb) triples — a helpdesk
operator might hold `restart-unit` on workstations and nothing on servers,
while rollouts to anything internet-facing require a second sign-off.
Break-glass exists, because reality, but it's a separate, alarmed path:
time-boxed, peer-approved, and impossible to use quietly.

## What you give up

Scoped means scoped. Ad-hoc "run this on every box" is gone on purpose,
imperative troubleshooting goes through break-glass, and none of this
extends to a Windows fleet. The bet is that for NixOS shops, the trade
buys an RMM that stays boring on the day your vendor's incident report
would otherwise have been *your* incident report.

## Status

In active development, dogfooded against the [homelab](/projects/homelab/)
fleet — every design decision gets tested where the blast radius is my own
evening. Design notes grow in the
[thought garden](/garden/declarative-fleet-management/).
