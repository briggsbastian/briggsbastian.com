---
title: 'Ember Baseline'
summary: 'An opinionated NixOS hardening module: CIS-informed defaults, auditd wiring, and kernel lockdown — security posture you can code-review.'
status: 'active'
year: '2025 — ongoing'
stack: ['NixOS', 'Nix Modules', 'auditd', 'AppArmor']
featured: false
order: 5
---

<!-- TODO(briggs): "Ember Baseline" is a placeholder working title and the
     feature list is fluff — replace with a real security project. -->

Hardening guides rot. They live in PDFs, get applied by hand, and drift the
moment someone troubleshoots at 2 a.m. **Ember Baseline** packages a
hardening posture as a NixOS module instead: import it, and the
baseline — kernel lockdown, auditd rules, SSH policy, sysctl tightening,
AppArmor profiles — is enforced by the same machinery that builds the
system.

- **Reviewable.** A security baseline as a diff, not a checklist. Changes to
  posture go through pull requests like any other code.
- **Provable.** Whether a host complies isn't a scan result — it's whether
  it's running the closure that includes the module.
- **Escapable on purpose.** Every control can be overridden per-host, but
  the override is visible in the repo forever. Exceptions become inventory
  instead of folklore.

Grew out of the [homelab](/projects/homelab/) and feeds directly into
[Hearthwatch](/projects/hearthwatch/)'s notion of what a managed host
should look like.
