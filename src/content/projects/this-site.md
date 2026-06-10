---
title: 'briggsbastian.com'
summary: 'This site, treated as a production system: Astro static build, Nix flake dev environment, CI pipeline, and a reproducible container image.'
status: 'shipped'
year: '2026'
stack: ['Astro', 'Nix Flakes', 'GitHub Actions', 'Docker']
featured: true
order: 3
links:
  github: 'https://github.com/briggsbastian'
---

<!-- TODO(briggs): point links.github at the real repo once pushed. -->

A portfolio site is the one project where the *how* is the portfolio. So
this site is deliberately run like something that matters:

- **Reproducible dev environment.** The toolchain is pinned in a Nix flake —
  `nix develop` on any machine yields the same Node, same everything. No
  "works on my laptop."
- **Static by default.** Astro renders the whole site to plain HTML at
  build time. No client-side framework runtime, no hydration, nothing to
  exploit at the edge. It scores like a static site because it is one.
- **Pipeline as the front door.** Every push runs type checks and a full
  build in CI before anything ships. The same pipeline can emit a
  multi-stage Docker image (build in Node, serve from nginx) for
  container-based hosting.
- **Content as data.** Projects and garden notes are markdown with typed,
  schema-validated frontmatter — bad metadata fails the build instead of
  shipping silently.

It's a small system, but it's a *complete* one: declared environment,
verified pipeline, reproducible artifact. The same shape scales up to the
fleets I run elsewhere.
