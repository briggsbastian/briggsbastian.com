---
title: 'Gesture'
summary: 'A deterministic 1v1 arena dueling prototype inspired by Dark Souls 3 combat. Godot 4, GDScript, fully data-driven, with the simulation built to go peer-to-peer later.'
status: 'in-development'
year: '2026'
stack: ['Godot 4', 'GDScript', 'Data-driven', 'Steam P2P (planned)']
featured: true
order: 1
---

**Gesture** is a skill-based 1v1 arena duel inspired by Dark Souls 3 combat.
There's no RPG layer, no loot, and no leveling. Two players pick a build,
fight a best-of-3, and the arena resets instantly between rounds. The only
progression is the build you choose before the match starts.

## What's there now

Milestone 1 is playable end to end: main menu, pre-match build selection, the
duel, and a results screen, with pause and settings. There's a Duel mode (two
players, keyboard and mouse against a gamepad) and a single-player Sandbox
against a training dummy, across three maps: an open Courtyard, a narrow Bridge
with no room to circle, and a foggy Jungle with cover.

## Combat

The combat is built around commitment and stamina, the way DS3's is.

- Every action costs stamina, and it only regenerates after a short pause. An
  attack just needs stamina above zero to start.
- Attacks are committed: startup, then active frames where the hitbox is live,
  then recovery. The timing lives in 60 Hz simulation ticks defined in data,
  not in the animation files.
- Rolling is the main defense. The roll tier (light, medium, heavy) comes from
  total equipment load, weapon weight plus armor class, and each tier trades
  i-frames and distance against recovery time.
- Poise decides who gets staggered. Poise damage accumulates, and exceeding
  your poise interrupts whatever you're doing. Heavy attacks carry hyper armor
  through it.
- Backstabs, parries (buckler, parry dagger, or a risky bare-handed one),
  ripostes, and lock-on are all in.

Builds are chosen before the match: a stat pool across Vigor, Endurance,
Strength, Dexterity, Intelligence, and Luck, plus a weapon class, an armor
class, and two throwables. Six weapon classes so far, each with its own moveset
and feel: Dagger, Straight Sword, Katana, Spear, Halberd, and Greatsword.

Two systems give a build its character. Imbues cycle through Fire, Lightning,
Dark, Ice, and Poison, and each element scales off a different stat (Fire on
Strength, Lightning on Dexterity, Dark on Intelligence, Ice on Endurance,
Poison on Luck) and adds its own rider, so every build leans toward a natural
element. Consumables sit on a DS-style d-pad cross: an estus flask to heal,
plus throwables like a firebomb, a smoke bomb that breaks lock-on, a dull bomb
that blocks healing, and a poison ball.

Hits read clearly: a brief freeze on contact, camera shake on the fighter who
got hit, and a ghost of recent damage trailing on the health bars.

## How it's built

The half I enjoy most is the architecture. Everything is data-driven: every
weapon, attack, armor class, roll, item, and imbue is a Godot Resource, so
tuning the game means editing data rather than code. The code stays strict: no
god objects, composition over inheritance, one small class per file, and every
system testable on its own. A headless smoke test runs a scripted duel with no
window open.

The simulation runs at a fixed 60 Hz with input separated from the simulation
logic. That separation is the point: the plan is Steam P2P multiplayer later,
and a deterministic sim with clean input handling is what makes that feasible.
Networking comes last, after the combat actually feels right. Notes on that
question grow in the [thought garden](/garden/netcode-for-honest-combat/).

## Status

A playable Milestone 1: real combat, six weapons, builds, imbues, consumables,
three maps, and the full match flow. Networking is the next large piece. Combat
feel is the metric I hold everything else to.
