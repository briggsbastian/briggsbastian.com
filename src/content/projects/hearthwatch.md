---
title: 'Hearthwatch'
summary: 'A scoped RMM built NixOS-first. Declarative fleet management with least-privilege agents — remote monitoring without handing out remote shells.'
status: 'in-development'
year: '2026'
stack: ['NixOS', 'Go', 'Nix Modules', 'gRPC']
featured: true
order: 2
---

<!-- TODO(briggs): "Hearthwatch" is a placeholder working title, and the
     architecture below is a plausible sketch — replace with the real design. -->

Traditional RMM tools are a standing contradiction: you install a
root-privileged remote-execution agent on every machine you manage, then
spend the rest of your career hoping it never gets popped. **Hearthwatch**
starts from the other end — what does fleet management look like when the
fleet is NixOS and the agent is allowed to do *almost nothing*?

## The premise

- **Declarative first.** On NixOS, "remediation" shouldn't mean a tech
  running ad-hoc shell commands. It means a config change, reviewed and
  rolled out — and rolled *back* — atomically. Hearthwatch treats the Nix
  configuration as the management plane.
- **Scoped by design.** The agent exposes a small, typed set of operations
  (report state, apply a signed generation, restart an allowlisted unit)
  instead of a remote shell. Every capability is granted per-host,
  per-operator, and logged.
- **Drift is a bug report.** Because the desired state is a Nix closure,
  drift detection is exact, not heuristic. The dashboard answers "which
  hosts are not running what the repo says" with a hash comparison.

## Why it exists

I wanted RMM ergonomics — fleet visibility, alerting, one-click rollout —
without importing the attack surface that commercial RMMs keep turning into
incident reports. NixOS makes the safer model not just possible but
*easier*, and nobody had built it.

## Status

In active development, dogfooding against my own fleet first. Design notes
grow in the [thought garden](/garden/).
