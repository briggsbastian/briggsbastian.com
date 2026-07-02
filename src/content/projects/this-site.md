---
title: 'briggsbastian.com'
summary: 'This site, treated as a production system: Astro static build, Nix flake dev environment, CI pipeline, and a reproducible container image.'
status: 'active'
year: '2026'
stack: ['Astro', 'Nix Flakes', 'Forgejo Actions', 'Docker']
featured: true
order: 3
links:
  github: 'https://github.com/briggsbastian'
---

<!-- TODO(briggs): point links.github at the real repo once pushed. -->

On a portfolio site, the *how* is part of the portfolio. So this one is run
like something that matters:

- **Reproducible dev environment.** The toolchain is pinned in a Nix flake:
  `nix develop` on any machine gives the same Node and the same everything,
  so there's no "works on my laptop."
- **Static by default.** Astro renders the whole site to plain HTML at
  build time. No client-side framework runtime, no hydration. Even the
  [interactive homelab topology](/projects/homelab/) is laid out at build
  time, with a few dozen lines of vanilla JS for hover focus and scroll
  polish. Performance is what you'd expect from a static site, because it
  nearly is one.
- **Everything goes through CI.** Every push to my self-hosted Forgejo
  runner runs type checks and a full build before anything ships. The same
  Dockerfile can emit a multi-stage image (build in Node, serve from nginx)
  for container hosting.
- **Content as data.** Projects and garden notes are markdown with typed,
  schema-validated frontmatter. Bad metadata fails the build instead of
  shipping silently.

It's a small system, but a *complete* one: declared environment, verified
pipeline, reproducible artifact. The same shape scales up to the fleets I
run elsewhere.
