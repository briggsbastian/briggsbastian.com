---
title: 'briggsbastian.com'
summary: 'This site, treated as a production system: Astro static build, Nix flake package, a gated CI pipeline on my own Forgejo, and a publish-on-green mirror feeding GitHub Pages.'
status: 'active'
year: '2026'
stack: ['Astro', 'Nix Flakes', 'Forgejo Actions', 'GitHub Pages']
featured: true
order: 3
links:
  github: 'https://github.com/briggsbastian/briggsbastian.com'
---

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
  runs type checks, a full build, a gitleaks secret scan, and a `nix build`
  of the deployable artifact. Only when every gate is green does a mirror
  job publish to the public GitHub repo — a red commit never leaves the
  house. (A Dockerfile can still emit a multi-stage nginx image for
  container hosting elsewhere.)
- **A reproducible artifact, hosted for free.** The site is also a Nix
  package (`nix build .#default`), proven by CI on every push, so any box
  with Nix can serve the identical bytes. Production is GitHub Pages fed
  by the gated mirror — zero hosting cost — and because the artifact is a
  derivation, moving it onto my own [fleet](/projects/homelab/) is a
  config change, not a migration.
- **Content as data.** Projects and garden notes are markdown with typed,
  schema-validated frontmatter. Bad metadata fails the build instead of
  shipping silently.

It's a small system, but a *complete* one: declared environment, verified
pipeline, reproducible artifact. The same shape scales up to the fleets I
run elsewhere.
