# lemonade.dev — frontend

Astro 製の個人サイト。デザインは Catppuccin Mocha + ターミナル風。

## 開発

```sh
pnpm install
pnpm dev       # http://localhost:4321
pnpm build     # dist/ に静的ビルド
pnpm preview   # ビルド結果の確認
```

リポジトリのルートに Nix flake があるので、`nix develop` で pnpm 入りのシェルに入れる。

## 構成

```
src/
├── components/   # Header, Footer, BaseHead など
├── content/blog/ # ブログ記事 (Markdown / MDX)
├── layouts/      # 記事レイアウト
├── pages/        # 各ページ (index, about, projects, now, uses, blog, 404)
└── styles/       # global.css (Catppuccin パレット定義)
```

## 記事の書き方

`src/content/blog/` に `.md` を置く。frontmatter は `title` / `description` / `pubDate`(任意で `updatedDate` / `heroImage`)。
