---
title: 'The pipeline is a product'
description: 'Internal tooling and CI deserve the same care as the thing they ship — arguably more, because everyone is forced to use them.'
stage: 'seedling'
planted: 2026-06-03
tended: 2026-06-03
topics: ['devops', 'ci']
---

Nobody chooses to use your CI pipeline. Every engineer on the team is a
captive user, dozens of times a day. That makes it the most-used product
your org ships — and usually the one with the worst UX, no owner, and no
error messages written for humans.

Things I believe so far:

- **A red build should explain itself.** If diagnosing a failure requires
  scrolling 4,000 lines of log, the pipeline has a bug, even though it
  "works."
- **Speed is a feature with a budget.** Decide what a push-to-green time
  *should* be and treat regressions like performance regressions, because
  that's what they are.
- **Reproducibility is the whole game.** "Re-run until green" is the
  pipeline teaching people not to trust it. Pinned toolchains (Nix is my
  hammer here) kill an entire class of flakiness at the root.

Seedling-stage question: does treating the pipeline as a product imply it
needs a *roadmap* — and if so, who plays product manager for a thing with
only internal, captive users?
