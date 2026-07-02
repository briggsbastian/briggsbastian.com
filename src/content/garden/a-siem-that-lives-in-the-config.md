---
title: 'A SIEM that lives in the config?'
description: 'I moved the homelab off Wazuh onto a declarative Loki/Alloy stack, and I honestly do not know yet whether it was the right call.'
stage: 'seedling'
planted: 2026-06-20
tended: 2026-07-01
topics: ['nixos', 'security', 'observability']
---

I ran Wazuh in the homelab, and I've now moved to a declarative stack
instead: Loki for the logs and the LogQL alert ruler, Grafana Alloy
shipping every host's journal, Alertmanager, and a self-hosted ntfy topic that
buzzes my phone, all defined in the flake. The reason I started down this road:
Wazuh's agent (FIM, vuln scanning, active response) was heavier than this lab
needs, and it kept its own state in containers, outside the config.

Here's the honest part. I don't actually know if this was the right call.
Trading Wazuh's real capabilities for something I can read in git feels
consistent with the rest of the estate being declarative, but I haven't run the
new stack long enough, or under anything resembling an attack, to say it holds
up. I'm completely unsure, and I'd rather write that down than pretend I've
settled it.

What I gave up to find out: FIM, vuln scanning, active response, and any log
history past 30 days (Loki's data refills from the journals rather than being
backed up). That's a real downgrade in raw capability.

The thing I can't answer yet: does a declarative log stack I tune myself
actually beat a heavier SIEM I treat as a black box, or am I just trading
capability for tidiness? The starter rules (SSH brute-force, repeated sudo
failures) are guesses until the purple-team phase points a Kali box at the lab
and I watch them fire. Until I've seen it catch something, it's untested config.
