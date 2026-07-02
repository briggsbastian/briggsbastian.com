# Deploying briggsbastian.com

The site is served from `cloud1` (the fleet's Linode NixOS host) as a Nix
package. There is no hosting platform in the loop: the private Forgejo repo
is the source of truth, CI on `hacktop` gates every push, and nginx on
`cloud1` serves the store path the flake builds.

```
push to Forgejo (git.mgmt.lan)
  └─ CI on hacktop: typecheck+build · gitleaks · nix build .#default
       └─ green + main → mirror force-pushes to github.com/briggsbastian/briggsbastian.com
            └─ (public shop window; GitHub Actions runs a build check only)

/etc/nixos flake has this repo as the `portfolio` input
  └─ nix flake update portfolio && colmena apply --on cloud1
       └─ nginx on cloud1 serves packages.default with a Let's Encrypt cert
```

## Day-to-day

- **Ship content:** commit, `git push`. When Forgejo CI is green the mirror
  updates. Then, on `desktop`:

  ```sh
  cd /etc/nixos
  nix flake update portfolio
  git add flake.lock && git commit -m "portfolio: bump site"
  colmena apply --on cloud1
  ```

  The site is a new store path; nginx picks it up atomically with the
  generation switch.

- **Rollback:** it's a NixOS generation. `colmena exec --on cloud1 -- \
  sudo nixos-rebuild --rollback switch`, or re-pin `portfolio` in
  `flake.lock` to the previous rev and apply.

- **Preview locally:** `nix develop -c npm run dev`, or build the real
  artifact with `nix build .#default` and serve `result/`.

## One-time setup (launch)

1. **Public mirror repo:** create an empty **public** GitHub repo
   `briggsbastian/briggsbastian.com` (no README). Add a GitHub fine-grained
   PAT with *Contents: Read/Write* on that repo as the Forgejo Actions
   secret `GH_MIRROR_TOKEN` (Forgejo → repo Settings → Actions → Secrets).
   Don't enable Forgejo's built-in push mirror — CI is the mirror.
2. **cloud1 vhost:** the fleet flake (`/etc/nixos`) carries the nginx
   vhost + ACME config and the `portfolio` flake input; 80/443 open in the
   host's nftables and the Linode Cloud Firewall.
3. **DNS (at the registrar):**

   | Type | Host  | Value            |
   | ---- | ----- | ---------------- |
   | A    | `@`   | cloud1's IP      |
   | A    | `www` | cloud1's IP      |

   Delete the old Vercel records (`76.76.21.21` A / `cname.vercel-dns.com`
   CNAME) — leftovers are the usual cause of a broken cutover.
4. **Certificate:** ACME (Let's Encrypt, HTTP-01) can only succeed once DNS
   points at cloud1; NixOS retries automatically, so expect a short
   cert-warning window (~minutes) right after the DNS flip.
5. **Verify, then tear down Vercel:**

   ```sh
   dig +short briggsbastian.com        # cloud1's IP, nothing else
   curl -sI https://briggsbastian.com  # 200, issuer Let's Encrypt
   ```

   Only after both check out, delete the project in the Vercel dashboard.

## Troubleshooting

- **Mirror job red, everything else green** — `GH_MIRROR_TOKEN` missing or
  expired in Forgejo repo secrets, or the GitHub repo doesn't exist yet.
- **Site serves but with the old content** — you pushed to Forgejo but
  didn't bump the flake input: `nix flake update portfolio` + apply.
- **Cert errors after cutover** — DNS still propagating or an old Vercel
  record lingering; check `dig +short` returns only cloud1's IP. ACME
  retries on its own once resolution is right.
- **`nix build .#default` hash mismatch after changing dependencies** —
  `package-lock.json` changed; recompute `npmDepsHash` with
  `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
