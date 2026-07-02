---
title: 'Does declarative config actually replace an RMM?'
description: 'RMMs are necessary for managing a fleet, and I am not convinced the declarative-everything story really replaces one. Where Colmena ends and an RMM begins.'
stage: 'seedling'
planted: 2026-04-12
tended: 2026-06-29
topics: ['nixos', 'homelab']
---

An RMM is necessary software. If you're managing a fleet of machines there
isn't really an alternative to a good one, and I'd rather not pretend the
declarative-everything story changes that.

For my own [homelab](/projects/homelab/) fleet, Colmena does the job. Every
host is a closure I deploy and roll back from one place, so I don't reach for
an RMM at all. But Colmena isn't an RMM, and it's worth being honest about why.
It manages machines I own, built to be uniform, that I understand top to
bottom. It says nothing about a fleet of normal users' machines that each do
one specific job and still need monitoring, remote hands, and support.

That gap is the idea NixRMM was circling: an enterprise-style
configuration-management tool for ultra-scoped machines, boxes that only do one
job, run by normal users. After living with Colmena I'm honestly not sure
what's left for it to be, or whether a declarative model buys enough over a
real RMM at that scale to be worth building.

So the open question, genuinely unresolved: is there a version of declarative
fleet management that competes with a good RMM for normal-user machines, or
does the declarative approach only win when you already own and understand
every box?
