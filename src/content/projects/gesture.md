---
title: 'Gesture'
summary: 'A souls-like PvP game where every swing is a commitment. Server-authoritative combat, lag-compensated hitboxes, and duels that feel fair at 80ms.'
status: 'in-development'
year: '2026'
stack: ['Unreal Engine 5', 'C++', 'GAS', 'Dedicated Servers']
featured: true
order: 1
---

<!-- TODO(briggs): engine/stack is a plausible guess — replace with the real
     details, and swap in real numbers wherever a figure appears below. -->

**Gesture** is a PvP-first souls-like: no bosses to grind, no world to save —
just you, an opponent, and a combat system that punishes panic and rewards
reads. The name is the thesis: in invasion-era dueling, the bow before the
fight mattered as much as the fight. This is a game about what you
communicate with your body before either blade moves.

## Design pillars

- **Commitment is the whole game.** Attacks can't be cancelled into safety.
  Every input is a bet, and the wager is stamina, position, and health.
- **The netcode is a mechanic.** A souls-like lives or dies on whether a
  trade *felt* legitimate. Combat is fully server-authoritative with
  lag-compensated hitboxes, so the player who read the duel correctly wins —
  not the player with the better route to the data center.
- **Legibility over spectacle.** Animations telegraph honestly. If you got
  hit, you should be able to say exactly why within half a second.

## The combat model

Three resources, no abstractions hidden from the player:

- **Stamina** prices every action — swing, roll, block, sprint. Running dry
  mid-exchange is the most common way to die, by design.
- **Poise** decides who interrupts whom when both attacks land inside the
  same window. Heavier weapons trade speed for the right to trade.
- **Position** is the resource people forget is a resource. Whiff
  punishment and spacing — the boring fundamentals — are where the skill
  ceiling actually lives.

Weapons are movesets, not stat sticks: a duelist should recognize an
opponent's options from the silhouette alone. The roster starts small
(five archetypes) and stays small until each one is honest.

## The netcode model

Server-authoritative simulation with lag-compensated hit validation —
closer to a competitive shooter than to a fighting game, and on purpose:

- **Commitment hides latency.** Long windups mean the server usually holds
  the full swing before the hit window opens. The genre's defining
  mechanic is also free latency masking.
- **The server owns the truth.** Clients predict their own movement and
  nothing else. Hits, trades, poise breaks, and backstabs resolve
  server-side against rewound hitboxes.
- **The edges are the hard part.** Backstab validation (no teleporting
  grabs), trade resolution inside the compensation window, and how much to
  trust the defender's view of a roll's i-frames. Each one gets settled by
  playtest data, not by argument.

Running notes on all of this grow in the
[thought garden](/garden/netcode-for-honest-combat/).

## The platform under it

The unglamorous half of a PvP game is fleet management, and it's the half I
enjoy most:

- Dedicated server builds are containerized in CI alongside the client
  build — same commit, same pipeline, no version skew between lobby and
  binary.
- A small allocator spins regional instances up when matchmaking demands
  and tears them down when lobbies drain. Idle fleets are a bill, not a
  flex.
- Server fleets emit health metrics from day one, so a bad netcode deploy
  shows up as a graph before it shows up as a forum thread.

Building the game and building the platform it runs on are the same
project — which is exactly why it's on this site.

## Status

Deep in development. Core combat loop is playable in private builds;
netcode model is the current battleground. Devlog entries land in the
[thought garden](/garden/) as they're worth writing down.
