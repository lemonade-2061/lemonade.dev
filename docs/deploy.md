# デプロイ手順 (Cloudflare Pages)

## 初回セットアップ

1. Cloudflare ダッシュボード → **Workers & Pages** → **Create** → **Pages** タブ → **Import an existing Git repository**
2. GitHub と連携して `lemonade-2061/lemonade.dev` を選ぶ
3. ビルド設定:

   | 項目 | 値 |
   | --- | --- |
   | Production branch | `main` |
   | Framework preset | `Astro` |
   | Build command | `pnpm build` |
   | Build output directory | `dist` |
   | Root directory (Advanced) | `frontend` |

   - Node のバージョンは `frontend/.node-version` (22) が使われる
   - pnpm は `pnpm-lock.yaml` から自動で判定される
   - 環境変数は今のところ不要

4. **Save and Deploy**。終わると `<プロジェクト名>.pages.dev` で見られる

## 独自ドメイン (lemonade.dev)

1. Pages プロジェクト → **Custom domains** → **Set up a custom domain** → `lemonade.dev` を入力
2. DNS の設定:
   - ドメインの DNS が Cloudflare にある場合: そのまま進めればレコードが自動で追加される
   - 他社 DNS の場合: 表示された CNAME (`<プロジェクト名>.pages.dev` 向け) をレジストラ側で追加する
3. 有効になるまで数分〜しばらく待つ (SSL 証明書も自動で発行される)

`www.lemonade.dev` も使うなら同じ手順で追加する。

## 普段の更新

- `main` に push すると自動でビルド・デプロイされる
- `main` 以外のブランチを push するとプレビュー用 URL が発行される (本番には出ない)
- 失敗したときは Pages プロジェクト → **Deployments** からビルドログを見る

## ブログ記事を出す流れ

1. `frontend/src/content/blog/` に Markdown を置く (frontmatter に `draft: true` を付けておく)
2. `pnpm dev` で確認しながら書く (dev では下書きも表示される)
3. 書き上がったら `draft: true` を消して `pubDate` を公開日にする
4. `main` に push
