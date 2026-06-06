# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`lemonade.dev` is a personal portfolio and blog. It's a monorepo with two parts:

- `frontend/` — an Astro site (React + Tailwind v4 islands). This is where essentially all current code lives.
- `backend/` — a Go service. Currently scaffolding only: `go.mod` exists but there are no `.go` source files yet. Tooling (`sqlc`, `air`, `postgresql`) is provisioned in the Nix devShell for future work.

## Environment

Development uses a Nix flake devShell, auto-loaded via direnv (`.envrc` is `use flake`). The devShell provides `nodejs`, `pnpm`, `go`, `postgresql`, `sqlc`, and `air`. Enter it with `nix develop` if not using direnv.

## Commands

Frontend (run from `frontend/`, uses **pnpm** — note the `pnpm-workspace.yaml`):

- `pnpm dev` — local dev server
- `pnpm build` — production build to `frontend/dist/`
- `pnpm preview` — preview the built site

There is no lint or test setup, and no CI. The backend, when implemented, is expected to use `air` for live reload and `sqlc` for type-safe Postgres queries.

## Frontend architecture

Built on the Astro blog starter conventions:

- **Content collections** (`src/content.config.ts`): a single `blog` collection loads `src/content/blog/**/*.{md,mdx}`. Frontmatter is Zod-validated — `title` and `description` are required; `pubDate` required; `updatedDate` and `heroImage` optional. Blog posts render through `src/pages/blog/[...slug].astro` → `src/layouts/BlogPost.astro`. `src/pages/blog/index.astro` lists posts and `src/pages/rss.xml.js` builds the feed.
- **Pages** (`src/pages/`): top-level routes are `index`, `about`, `projects`, `uses`, `now`. Site-wide values (`SITE_TITLE`, `SITE_DESCRIPTION`) live in `src/consts.ts`.
- **Shared components** (`src/components/`): `BaseHead` (per-page `<head>`/SEO), `Header`/`HeaderLink`, `Footer`, `FormattedDate`. Pages compose `BaseHead` + `Header` + `<main>` + `Footer`.
- **Styling**: Tailwind v4 via the `@tailwindcss/vite` plugin (configured in `astro.config.mjs`, not a `tailwind.config`). Global styles and the **Catppuccin Mocha** color palette (CSS custom properties like `--ctp-base`, `--ctp-mauve`) are defined in `src/styles/global.css`. Prefer these palette variables for colors.
- `astro.config.mjs` sets `site: 'https://lemonade.dev'` and enables the `mdx`, `sitemap`, and `react` integrations.

Site copy and UI text are primarily in Japanese (`<html lang="ja">`).
