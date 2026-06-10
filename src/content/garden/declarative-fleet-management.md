---
title: 'RMM is a remote shell with a dashboard (and it shouldn’t be)'
description: 'Why remote management tooling keeps becoming the breach, and what a declarative, least-privilege alternative looks like on NixOS.'
stage: 'budding'
planted: 2026-04-12
tended: 2026-06-07
topics: ['nixos', 'security', 'nixrmm']
---

Strip the marketing off most RMM products and you find the same primitive:
a root agent that accepts arbitrary commands from a cloud control plane.
That's not a management tool, that's a botnet with an invoice. The supply
chain only has to fail once — and the industry keeps demonstrating that it
does.

## The inversion

The fix isn't a better-guarded shell; it's removing the shell. On NixOS the
desired state of a machine is already a single, hashable artifact — the
system closure. So fleet management can be restated:

- **Management = publishing a new closure.** Signed, reviewed, atomic,
  rollback included by construction.
- **Monitoring = comparing hashes.** Drift detection stops being a
  heuristic scan and becomes an equality check.
- **The agent = a verifier, not an executor.** It reports state, fetches
  signed generations, and restarts allowlisted units. Its compromise is
  annoying, not catastrophic.

## What you give up

Honesty requires the costs: ad-hoc "just run this on every box" is gone on
purpose, break-glass needs a separate audited path, and none of this
extends to the Windows fleet your MSP actually bills for. Scoped means
*scoped*. I think the trade is right anyway — that's the bet
[NixRMM](/projects/nixrmm/) is making.

## Open questions

- How much imperative escape hatch can you allow before you've rebuilt the
  remote shell with extra steps?
- Is per-operator capability granting usable at 200 hosts, or does it decay
  into "everyone gets everything" like every RBAC system before it?
