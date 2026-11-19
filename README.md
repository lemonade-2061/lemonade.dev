# lemonade.dev

Personal portfolio and blog. Built with Astro on Nix.

Live: <https://lemonade.dev> (準備中)

## Tech Stack

- **Frontend**: Astro + React Islands + Tailwind (static build)
- **Hosting**: Cloudflare Pages
- **Dev env**: Nix flake (devShell)
- **Backend**: 未使用。動的な機能が必要になったら Pages Functions で足す予定 (`backend/` は Go 用に確保しているだけ)

## Development

```sh
nix develop
cd frontend
pnpm install
pnpm dev
```

## Blog

記事は `frontend/src/content/blog/` に Markdown で置く。frontmatter に `draft: true` を書くと本番ビルドから除外される (dev では表示される)。

## Deploy

`main` に push すると Cloudflare Pages がビルドする。

- Root directory: `frontend`
- Build command: `pnpm build`
- Build output directory: `dist`

詳しい手順 (初回セットアップ・独自ドメイン) は [docs/deploy.md](docs/deploy.md)。
