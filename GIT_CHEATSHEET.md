# Git カンニングペーパー 📝

困ったときに上から眺めれば思い出せる用。

---

## 🧭 まず状況を見る

```bash
git status              # いま何が変更されてるか
git branch              # ブランチ一覧（* が今いる場所）
git branch -a           # リモート含む全ブランチ
git log --oneline       # コミット履歴を1行ずつ
git log --oneline --graph --all   # 履歴を枝つきで可視化（神コマンド）
git diff                # まだステージしてない変更
git diff --staged       # ステージ済みの変更
```

---

## 💾 変更を記録する（add → commit）

```bash
git add ファイル名        # 特定ファイルをステージ
git add .                # 全部ステージ
git commit -m "メッセージ"
git commit -am "メッセージ"   # add + commit を一気に（既存ファイルのみ）
```

### やり直し系

```bash
git commit --amend -m "新メッセージ"   # 直前のコミットを修正（※push前だけ）
git restore ファイル名      # 変更を破棄（編集前に戻す）
git restore --staged ファイル名   # ステージから降ろす（変更は残る）
```

---

## 🌿 ブランチ操作

```bash
git switch ブランチ名        # ブランチを切り替え
git switch -c 新ブランチ名    # 作って切り替え（-c = create）
git branch -d ブランチ名      # ブランチ削除（マージ済みのみ）
git branch -D ブランチ名      # 強制削除

# 古い書き方（同じことができる）
git checkout ブランチ名
git checkout -b 新ブランチ名
```

---

## 🔄 リモートと同期する

```bash
git fetch origin          # リモートの最新を取得（マージはしない＝安全）
git pull                  # fetch + merge を一気に
git push                  # ローカルのコミットをリモートへ
git push -u origin ブランチ名   # 初回push（追跡設定つき）
```

### ⭐ 作業ブランチを最新mainに追従させる（重要）

```bash
# rebase版（履歴がキレイ・自分専用ブランチ向き）
git pull --rebase origin main

# merge版（安全・共有ブランチ向き）
git pull origin main
```

> ローカルmainを更新してから…の2段階は不要。
> 作業ブランチにいる状態で直接 `origin/main` を取り込める。

---

## 🔀 merge と rebase

```bash
git merge ブランチ名          # 指定ブランチを今のブランチに合流（マージコミットが残る）
git rebase ブランチ名         # 今のブランチの土台を付け替え（履歴が一直線・作り直し）
```

### 使い分けの本質

> **push前の自分のコミット → rebase OK（書き換えて良い）**
> **共有済みのコミット → merge（書き換えるな）**

| 状況 | 推奨 |
|---|---|
| 個人開発 / 自分専用ブランチ | `rebase` |
| みんなが共有するブランチ（main等） | `merge` |
| 本流へ最終統合（PRマージ） | `merge` |

---

## ⚔️ コンフリクト解決

> **コンフリクト = 壊れた、ではない。** 同じ行を別々に変えたとき、Gitが「どっち採用する？」と人間に判断を仰いでるだけ。落ち着いて直せばOK。

### 直し方の本体（merge / rebase / PR すべて共通）

衝突したファイルを開くと、こうなってる：

```
<<<<<<< HEAD
こっち側（取り込もうとしてる方）
=======
あっち側（自分のコミット側）
>>>>>>> 作業コミット
```

この `<<<<<<<` `=======` `>>>>>>>` の**記号ごと消して**、最終的に正しい形へ手で直す。
（片方採用 / 両方残す / 書き直す、は自由。どうあるべきかを人間が決める）

```bash
git status               # ① どのファイルが衝突してるか確認（both modified）
# ② ファイルを開いて記号を消して直す
git add 直したファイル      # ③ 「直したよ」とGitに伝える
```

### 最後の一手だけ merge / rebase で違う

| 場面 | 解決後のコマンド |
|---|---|
| **merge** 中の衝突 | `git add` → `git commit` |
| **rebase** 中の衝突 | `git add` → `git rebase --continue` |

### 詰んだら安全脱出（衝突前の状態に完全に戻る）

```bash
git merge --abort         # merge中なら
git rebase --abort        # rebase中なら
```

### merge と rebase の衝突の違い

| | merge | rebase |
|---|---|---|
| 衝突回数 | 1回でまとめて | コミット数だけ繰り返す可能性 |
| 解決後 | `commit` | `--continue` |
| 直し方の本体 | **同じ** | **同じ** |

> rebaseはコミットを1個ずつ乗せ直すので「また衝突した！」が起きるが、別コミット分なので正常。1個ずつ片付ければ必ず終わる。

---

## ⏪ 取り消し・巻き戻し

```bash
git reset --soft HEAD~1    # 直前コミットを取消（変更は残す・ステージ済み）
git reset HEAD~1           # 直前コミットを取消（変更は残す・未ステージ）
git reset --hard HEAD~1    # 直前コミットを完全に消す（⚠️変更も消える）

git revert コミットID        # 指定コミットを「打ち消すコミット」を作る（共有済みでも安全）
```

> `reset --hard` は戻せないことがある。共有済み履歴には `revert` を使う。

---

## 🧰 一時退避（stash）

```bash
git stash               # 今の変更を一時退避（作業台をきれいに）
git stash list          # 退避リスト
git stash pop           # 退避を戻す（戻して削除）
git stash apply         # 退避を戻す（リストには残す）
git stash drop          # 退避を捨てる
```

> 「今すぐブランチ切り替えたいけどコミットしたくない」ときの神機能。

---

## 🆘 困ったとき

```bash
git reflog              # 過去のHEAD移動履歴（消したコミットを救出できる）
git checkout コミットID    # 過去の状態を覗く
git show コミットID        # そのコミットの中身を見る
```

> `reflog` は最後の命綱。「やらかした！」と思ったらまずこれ。

---

## 📎 用語ミニ辞典

| 用語 | 意味 |
|---|---|
| `HEAD` | いま自分がいる位置（最新コミットを指すことが多い） |
| `HEAD~1` | HEADの1つ前のコミット |
| `origin` | リモートリポジトリの標準的な名前 |
| `origin/main` | リモートのmainブランチの状態を指すポインタ |
| ステージ | コミットに含める変更を選んで置いておく場所 |

---

*個人開発ベースなので基本 rebase 中心でOK。共有ブランチを触るときだけ merge を思い出す、くらいの温度感で。*
