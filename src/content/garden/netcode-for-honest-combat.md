---
title: 'Netcode for honest combat'
description: 'Souls-like PvP lives or dies on whether a trade felt legitimate. Notes on picking a netcode model when "fairness" is the core mechanic.'
stage: 'seedling'
planted: 2026-05-20
tended: 2026-05-28
topics: ['gamedev', 'netcode', 'ashfall']
---

Fighting games solved their netcode problem with rollback, and everyone now
recites "rollback good" as a creed. But a souls-like isn't a fighting game:
movement is analog and continuous, hit volumes are 3D and animation-driven,
and encounters aren't a clean 1v1 in a flat arena. The creed doesn't
transfer cleanly.

Current thinking, loosely held:

- **Full rollback** is brutal with animation-driven 3D hitboxes — resimulating
  several frames of ragdoll-adjacent state per correction is real CPU, and
  visual rollback artifacts undermine the "weighty" feel worse than delay does.
- **Server-authoritative + lag compensation** (the shooter model) fits
  better than expected, *because attacks are committed*. Long windups mean
  the server usually has the full swing before the hit window opens — the
  commitment that defines the genre is also free latency hiding.
- The real fights are at the edges: backstab validation (teleporting grabs
  are the genre's shame), trade resolution when both swings land within the
  compensation window, and how much the defender's reality should be trusted
  on a roll's i-frames.

Suspicion to test: souls-likes have *less* of a netcode problem than
fighting games, not more, and the genre's bad reputation comes from peer-to-peer
legacy rather than anything inherent. If the suspicion holds,
[Ashfall](/projects/ashfall/) ships server-authoritative and never looks back.
