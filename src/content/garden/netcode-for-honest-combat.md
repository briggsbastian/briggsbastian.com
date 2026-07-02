---
title: 'Netcode for honest combat'
description: 'In a 1v1 duel, a trade only feels fair if both players saw the same fight. Notes on why Gesture is built deterministic and peer-to-peer, with networking left for last.'
stage: 'seedling'
planted: 2026-05-20
tended: 2026-06-29
topics: ['gamedev', 'netcode', 'gesture']
---

[Gesture](/projects/gesture/) is a 1v1 arena duel where every swing is
committed, so a trade only feels fair if both players' machines computed the
same fight from the same inputs. That's why I'm building the simulation to be
deterministic from the start, instead of adding networking later and hoping it
reconciles.

Current thinking, loosely held:

- **Determinism is the fairness guarantee.** The sim runs at a fixed 60 Hz
  with input kept separate from simulation logic. If both peers step the same
  inputs through the same deterministic sim, they land on the same state
  without a server refereeing every hit. That's the rollback and lockstep
  family, the approach fighting games use, and for a clean 1v1 it fits better
  than the shooter's server-authoritative model.
- **Commitment buys some slack.** Attacks have real startup before the hitbox
  goes live, so there's a window to exchange and reconcile inputs before
  anything lands. The mechanic that defines the genre also helps the netcode.
- **The hard cases are at the edges:** backstab validation (no teleporting
  grabs), trade resolution when both swings land on the same tick, and how
  much a roll's i-frames can be trusted across a connection.

The discipline that matters right now isn't the netcode itself. It's keeping
the sim deterministic and the input layer separate so P2P can be added later
without rewriting combat. Networking comes last on purpose: the fight has to
feel right offline first. Steam P2P is the target once it does.
