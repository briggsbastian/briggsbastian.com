---
title: 'Ashfall'
summary: 'A souls-like PvP game where every swing is a commitment. Server-authoritative combat, lag-compensated hitboxes, and duels that feel fair at 80ms.'
status: 'in-development'
year: '2026'
stack: ['Unreal Engine 5', 'C++', 'GAS', 'Dedicated Servers']
featured: true
order: 1
---

<!-- TODO(briggs): "Ashfall" is a placeholder working title, and the engine/stack
     below is a plausible guess — replace with the real details. -->

**Ashfall** is a PvP-first souls-like: no bosses to grind, no world to save —
just you, an opponent, and a combat system that punishes panic and rewards
reads. Think invasion-era dueling distilled into its own game.

## Design pillars

- **Commitment is the whole game.** Attacks can't be cancelled into safety.
  Every input is a bet, and the wager is stamina, position, and health.
- **The netcode is a mechanic.** A souls-like lives or dies on whether a
  trade *felt* legitimate. Combat is fully server-authoritative with
  lag-compensated hitboxes, so the player who read the duel correctly wins —
  not the player with the better route to the data center.
- **Legibility over spectacle.** Animations telegraph honestly. If you got
  hit, you should be able to say exactly why within half a second.

## Where the DevOps bleeds in

The unglamorous half of a PvP game is fleet management, and it's the half I
enjoy most. Dedicated servers are built as containers in CI, deployed
regionally, and torn down when the lobbies drain. The matchmaker is just an
allocator with opinions. Building the game and building the platform it runs
on are the same project — which is exactly why it's on this site.

## Status

Deep in development. Core combat loop is playable in private builds;
netcode model is the current battleground. Devlog entries land in the
[thought garden](/garden/) as they're worth writing down.
