# Deploying briggsbastian.com

Production is **GitHub Pages**, but GitHub never sees an ungated commit:
the private Forgejo repo is the source of truth, CI on `hacktop` gates
every push, and only green commits reach the public mirror that Pages
serves from.

```
push to Forgejo (git.mgmt.lan)
  └─ CI on hacktop: typecheck+build · gitleaks · nix build .#default
       └─ green + main → mirror force-pushes to github.com/briggsbastian/briggsbastian.com
            └─ GitHub Actions builds again and deploys to GitHub Pages
                 └─ https://briggsbastian.com
```

The repo also builds as a Nix package (`nix build .#default`) — CI proves
the derivation on every push, and any box with Nix can serve `result/`.
That kept the exit ramp open: self-hosting the same artifact on a fleet
host is config that already existed once (see git history for the cloud1
nginx vhost) and can come back whenever an off-site host does.

## Day-to-day

- **Deploy:** commit, `git push` (to Forgejo). Green CI mirrors to GitHub,
  GitHub deploys. Live in ~2–3 minutes end to end.
- **Rollback:** `git revert <bad-commit> && git push` — ships like any
  other commit.
- **Preview locally:** `nix develop -c npm run dev`, or build the real
  artifact with `nix build .#default` and serve `result/`.

## One-time setup (launch)

1. **Public mirror repo:** create an empty **public** GitHub repo
   `briggsbastian/briggsbastian.com` (no README, no .gitignore). Add a
   fine-grained PAT with *Contents: Read/Write* on that repo as the
   Forgejo Actions secret `GH_MIRROR_TOKEN` (Forgejo → repo Settings →
   Actions → Secrets). Don't enable Forgejo's built-in push mirror — CI
   is the mirror. Re-run the failed `mirror` job (or push any commit).
2. **Enable Pages:** GitHub repo → Settings → Pages → Source:
   **GitHub Actions**. Re-run the failed deploy if needed. Check the
   fallback URL (`briggsbastian.github.io/briggsbastian.com`) renders
   before touching DNS (styles 404 there — expected; the build targets
   the domain root).
3. **DNS (at the registrar):**

   | Type  | Host  | Value                     |
   | ----- | ----- | ------------------------- |
   | A     | `@`   | `185.199.108.153`         |
   | A     | `@`   | `185.199.109.153`         |
   | A     | `@`   | `185.199.110.153`         |
   | A     | `@`   | `185.199.111.153`         |
   | CNAME | `www` | `briggsbastian.github.io` |

   Delete the old Vercel records (`76.76.21.21` A / `cname.vercel-dns.com`
   CNAME) — leftovers are the usual cause of a broken cutover.
4. **Custom domain:** repo → Settings → Pages → Custom domain →
   `briggsbastian.com`. GitHub verifies DNS, provisions a Let's Encrypt
   cert (minutes up to ~an hour), then tick **Enforce HTTPS**.
5. **Verify, then tear down Vercel:**

   ```sh
   dig +short briggsbastian.com        # the four 185.199.* IPs, nothing else
   curl -sI https://briggsbastian.com  # 200 over HTTPS
   ```

   Only after both check out, delete the project in the Vercel dashboard.

## Troubleshooting

- **Mirror job red on Forgejo, everything else green** — `GH_MIRROR_TOKEN`
  missing/expired in Forgejo repo secrets, or the GitHub repo doesn't
  exist yet.
- **Deploy job fails with a Pages/environment error** — Pages isn't
  enabled, or Source isn't "GitHub Actions" (step 2).
- **"Domain's DNS record could not be retrieved"** — propagation lag or a
  leftover Vercel record; `dig +short briggsbastian.com` should return
  only the four `185.199.*` addresses.
- **`nix build .#default` hash mismatch after changing dependencies** —
  `package-lock.json` changed; recompute `npmDepsHash` with
  `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
