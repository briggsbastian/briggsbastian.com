# Deploying to GitHub Pages

This site deploys itself: the workflow in `.github/workflows/ci.yml` builds
and publishes to GitHub Pages on every push to `main`. Unlike Vercel, there
is no platform watching the repo — the CI pipeline in this repo *is* the
deployer. Setup is one-time; after that, deploying is just `git push`.

## One-time setup

### 1. Create the GitHub repo and push

The repo must be **public** (GitHub Pages on a free account requires it).

```sh
# from this directory, after creating an empty repo named
# "briggsbastian.com" at https://github.com/new (no README, no .gitignore)
git remote add origin git@github.com:briggsbastian/briggsbastian.com.git
git push -u origin main
```

The push triggers the CI workflow. The `build` job will pass; the `deploy`
job will fail until step 2 is done — that's expected.

### 2. Enable GitHub Pages

Repo → **Settings → Pages** → under *Build and deployment*, set
**Source: GitHub Actions**.

Then re-run the failed deploy (repo → **Actions** → select the run →
**Re-run failed jobs**), or just push any commit. When it finishes, the site
is live at `https://briggsbastian.github.io/briggsbastian.com/` — check it
works before touching DNS.

> If the repo is named anything other than `<username>.github.io`, the
> fallback URL has that path suffix. Once the custom domain is set, the
> suffix disappears and all links resolve from the domain root, which is
> what `astro.config.mjs` (`site: 'https://briggsbastian.com'`) assumes.

### 3. Point the domain at GitHub

At your DNS provider (wherever briggsbastian.com is registered):

| Type  | Host  | Value                     |
| ----- | ----- | ------------------------- |
| A     | `@`   | `185.199.108.153`         |
| A     | `@`   | `185.199.109.153`         |
| A     | `@`   | `185.199.110.153`         |
| A     | `@`   | `185.199.111.153`         |
| CNAME | `www` | `briggsbastian.github.io` |

Remove any old A/CNAME records for `@` and `www` pointing at the previous
host (e.g. Vercel's `76.76.21.21` / `cname.vercel-dns.com`) — leftovers are
the most common cause of a broken cutover.

### 4. Set the custom domain

Repo → **Settings → Pages** → *Custom domain* → enter `briggsbastian.com`
and save. GitHub verifies DNS (can take a few minutes up to ~an hour for
propagation), then provisions a Let's Encrypt certificate automatically.
When the cert is ready, tick **Enforce HTTPS**.

Done. `https://briggsbastian.com` is live and stays in sync with `main`.

## Day-to-day

- **Deploy:** `git push`. Live in ~1–2 minutes. Watch progress in the
  **Actions** tab.
- **Pull requests:** the `build` job runs as a check (typecheck + build);
  nothing deploys until merged to `main`. There are no per-PR preview URLs —
  use `npm run dev` locally instead.
- **Rollback:** `git revert <bad-commit> && git push`. The pipeline ships
  the reverted state like any other commit.

## Troubleshooting

- **Deploy job fails with a Pages/environment error** — Pages isn't enabled
  yet, or Source isn't set to "GitHub Actions" (step 2).
- **"Domain's DNS record could not be retrieved"** — propagation lag, or an
  old record still pointing elsewhere. Check with
  `dig +short briggsbastian.com` — it should return the four `185.199.*`
  addresses and nothing else.
- **"Enforce HTTPS" greyed out / cert pending** — normal for the first hour
  after the domain verifies; it sorts itself out.
- **Site loads but styles/links 404 on the github.io URL** — expected on the
  path-suffixed fallback URL; the build targets the custom domain root.
  Verify on `briggsbastian.com` once DNS is set.
- **Custom domain resets after a deploy** — shouldn't happen with the
  Actions deployment method (the setting lives in repo Settings, not in the
  artifact), but if it ever does, re-enter it in Settings → Pages.
