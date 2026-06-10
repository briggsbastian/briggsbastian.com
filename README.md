# briggsbastian.com

Personal portfolio and thought garden. Astro static site, "Forge" theme —
warm near-black, ember accent, editorial serif. The garden swaps the ember
for moss.

## Stack

- **[Astro 5](https://astro.build)** — fully static output, zero client JS
- **Content collections** — projects and garden notes are markdown with
  schema-validated frontmatter (`src/content.config.ts`)
- **Hand-rolled CSS** — design tokens in `src/styles/global.css`, no framework
- **Nix flake** — pinned dev environment (`nix develop`, or direnv via `.envrc`)
- **GitHub Actions** — typecheck + build on every push, deploy from `main`
- **Dockerfile** — optional reproducible nginx image for container hosting

## Develop

```sh
nix develop          # or: nix-shell -p nodejs_22
npm install
npm run dev          # localhost:4321
```

`npm run check` typechecks, `npm run build` emits `dist/`.

## Content

| What | Where | Notes |
| --- | --- | --- |
| Projects | `src/content/projects/*.md` | `featured: true` + `order` control the homepage |
| Garden notes | `src/content/garden/*.md` | `stage`: seedling → budding → evergreen; bump `tended` when you edit |

Placeholder/fluff copy is marked with `TODO(briggs)` comments — grep for it:

```sh
grep -rn "TODO(briggs)" src/
```

## Deploy

CI deploys `main` to GitHub Pages (enable Pages → Source: GitHub Actions,
then point the `briggsbastian.com` custom domain at it). Alternatively build
the Docker image and run it anywhere:

```sh
docker build -t briggsbastian.com .
docker run -p 8080:80 briggsbastian.com
```
