---
title: 'RMM is a remote shell with a dashboard (and it shouldn’t be)'
description: 'Why remote management tooling keeps becoming the breach, and what a declarative, least-privilege alternative looks like on NixOS.'
stage: 'budding'
planted: 2026-04-12
tended: 2026-06-10
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

- **Management = rebuilding to a known-good target.** Patching and
  reconfiguration become the same operation: apply a version-pinned
  closure, atomically, with rollback included by construction — a health
  check the new generation must pass, or the host reverts on its own.
- **Monitoring = comparing against the declared state.** Drift detection
  stops being a heuristic scan and becomes an equality check between what
  the host runs and what the catalog says it should.
- **The agent = a snapshot endpoint, not a root shell.** State flows out;
  new systems arrive as whole closures. The agent's compromise is
  annoying, not catastrophic.
- **Human hands = a brokered session, not an agent backdoor.** When an
  operator genuinely needs a shell or a desktop, that's an in-browser
  SSH/RDP session through a central broker — attributable, audited, and
  cleanly separated from the management plane the agent lives on.

## What you give up

Honesty requires the costs: ad-hoc "just run this on every box" is gone on
purpose — fleet-wide change means publishing a new setup, not a script.
There's no alerting, no log retention, no CVE scanning in the first cut,
and none of this extends to the Windows fleet your MSP actually bills
for. Scoped means *scoped*. I think the trade is right anyway — that's
the bet [NixRMM](/projects/nixrmm/) is making.

## Open questions

- How much imperative escape hatch can you allow before you've rebuilt the
  remote shell with extra steps? Brokered sessions answer *attribution*,
  but not the deeper question of how much should ever be done by hand.
- Latest-snapshot-only monitoring is refreshingly cheap — but where's the
  line where "no history" stops being discipline and starts hiding
  patterns an operator needed to see?
