---
title: Git cheatsheet
description: Basic git cheat sheat 
created: 2025-09-23
updated: 2025-09-23
environment: ubuntu desktop
genai:
    - deepseek
visibility: public
status: done
tags:
    - git
    - cheatsheet
---
# Gitチートシート

## 基本操作

### リポジトリの初期化
```bash
git init             # 新規リポジトリを作成
git init --bare      # 新規bareリポジトリを作成
git clone <repo-URL> # 既存リポジトリをクローン
```

### ステータス確認
```bash
git status         # ステータス確認
git diff           # 変更内容の詳細確認
git log            # コミット履歴確認
git log --oneline  # 1行表示
```

## 変更の管理

### ファイルの追加・コミット
```bash
git add .                # 全ての変更を追加
git commit -m "message"  # コミット
git commit -am "message" # ステージングとコミット（新規ファイル以外）
```

### 変更の取り消し
```bash
git checkout -- <file name> # ステージング前の変更を取り消し
git reset HEAD <file name>  # ステージングした変更を取り消し
git commit --amend          # 直前のコミットをやり直し
```

### 変更の確認
```bash
git diff                      # ステージングされていない変更を確認
git diff <name>               # 特定ファイルのみ確認
git diff --staged             # ステージング済みの変更を確認
git diff HEAD                 # ステージ済み＋未ステージの全ての変更を確認
git diff <hash>               # 現在と特定のコミットの差分
git diff <branch1>..<branch2> # 2つのブランチ間の差分
```

## ブランチ操作

### ブランチの管理
```bash
# ブランチ一覧表示
git branch
git branch -a        # リモート含む全てのブランチ
git branch <name>    # 新規ブランチ作成
git switch <name>    # ブランチ切り替え
git switch -c <name> # ブランチ作成＋切り替え
git merge <name>     # ブランチをマージ
git rebase <name>    # ブランチをリベース

# コンフリクト解決後
git add .
git rebase --continue
```

## リモート操作

### リモートリポジトリの管理
```bash
git remote -v               # リモートリポジトリの確認
git remote add <name> <URL> # リモートリポジトリの追加
git fetch                   # リモートから最新情報を取得

# pull
git pull                    # fetch + merge
git pull <remote> <branch>  # リモートのブランチ指定
git pull --rebase           # リベースでプル

# push
git push                  # 変更をプッシュ
git push -u origin <name> # 初回プッシュ（ブランチを設定）
git push --tags           # タグのプッシュ
```

## その他の便利コマンド

### スタッシュ
```bash
git stash      # 一時的に変更を退避
git stash list # 退避した変更をリスト表示
git stash pop  # 退避した変更を復元
```

### タグ
```bash
git tag <name>                 # タグの作成
git tag -a <name> -m "message" # 注釈付きタグの作成
git tag                        # タグの一覧表示
```

### 設定
```bash
# ユーザー設定
git config --global user.name "name"
git config --global user.email "mail@example.com"

# エイリアスの設定
git config --global alias.br branch
git config --global alias.s status
git config --global alias.co checkout
git config --global alias.cm "commit -m"
git config --global alias.br branch
git config --global alias.lg "log --oneline --graph --all"

# 全ての設定確認
git config --global --list
```

### 使い方詳細

```bash
git diff --help
git commit --help
```
