---
title: 'What’s really in this image?'
description: 'A planned experiment: comparing what a container claims to contain against what a Nix closure can prove. Notes once I run it.'
stage: 'seedling'
planted: 2026-06-26
tended: 2026-06-29
topics: ['security', 'supply-chain', 'nixos']
---

A container image is a stack of tarballs, and the thing telling you what's
inside is mostly a tag you decided to trust. The SBOM, if there is one, usually
lives next to the artifact and isn't forced to match it. Nix closures work the
other way: every dependency is pinned by hash, and a tool like `sbomnix` reads
the closure and reports what actually went in, rather than taking the package's
word for it.

This is on my list, not something I've done yet. The plan is to take a
container I actually run, tear it apart on the [playground lab](/projects/homelab/)
with REMnux and FLARE tooling, build the `dockerTools.buildImage` equivalent,
and compare what the image claims against what Nix can prove. The write-up only
counts once the lab has actually generated it, so this note is a placeholder
until then.
