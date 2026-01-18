---
title: jq
description: jq cheatsheet
updated: 2026-01-18
genai:
    - deepseek
visibility: public
status: wip
tags:
    - json
---
# jq cheatsheet
`jq` は JSON データを処理するための強力なコマンドラインツールです。

バージョン情報
```sh
$ apt show jq | head

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Package: jq
Version: 1.7.1-3ubuntu0.24.04.1
Priority: optional
Section: utils
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: ChangZhuo Chen (陳昌倬) <czchen@debian.org>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 115 kB
Depends: libc6 (>= 2.38), libjq1 (= 1.7.1-3ubuntu0.24.04.1)
```

動作確認に使用したjsonファイル
<details>
    <summary>example.json</summary>
```json
{
  "users": [
    {
      "id": 1,
      "name": "Alice",
      "age": 28,
      "email": "alice@example.com",
      "hobbies": ["reading", "hiking"],
      "address": {
        "city": "Tokyo",
        "zip": "100-0001"
      }
    },
    {
      "id": 2,
      "name": "Bob",
      "age": 35,
      "email": "bob@example.com",
      "hobbies": ["gaming", "cooking"],
      "address": {
        "city": "Osaka",
        "zip": "530-0001"
      }
    },
    {
      "id": 3,
      "name": "Charlie",
      "age": 42,
      "email": "charlie@example.com",
      "hobbies": ["photography"],
      "address": {
        "city": "Tokyo",
        "zip": "100-0002"
      }
    }
  ],
  "products": [
    {"id": "P001", "name": "Laptop", "price": 1200, "stock": 15},
    {"id": "P002", "name": "Mouse", "price": 25, "stock": 100},
    {"id": "P003", "name": "Keyboard", "price": 80, "stock": 30}
  ],
  "orders": [
    {"user_id": 1, "product_id": "P001", "quantity": 1},
    {"user_id": 2, "product_id": "P002", "quantity": 3},
    {"user_id": 1, "product_id": "P003", "quantity": 2}
  ]
}
```
</details>


## 基本的な使い方

```bash
# パイプで渡す
cat example.json | jq .

# 引数で渡す
jq . example.json

# キーの一覧
# jqクエリ内でパイプ使用の場合はシングルクォートで囲う
jq '. | keys' example.json

# キー指定
jq .users example.json
jq .users[].name example.json  # ネストしたキー

# 複数ファイルを配列として結合
jq -s '.' file1.json file2.json

# 複数ファイルを個別に処理
jq '.key' *.json
```

## 便利なオプション

```bash
# コンパクトな出力
jq -c '.' example.json

# 生の文字列として出力（クォートなし）
jq -r '.orders[].product_id' example.json

# デフォルト値の設定
jq '.name // "default"' example.json
```


## 配列操作

```bash
# 配列要素にアクセス
jq .products[0] example.json         # 最初の要素
jq .products[1] example.json         # 2番目の要素
jq .products[-1] example.json        # 最後の要素

# 配列をフィルタリング
jq '.users[] | select(.age > 30)' example.json
jq '.users[] | select(.address.zip | contains("100"))' example.json

# 条件分岐
jq '.users[] | if .age > 30 then "adult" else "minor" end' example.json

# 複数条件
jq '.users[] | select(.age > 30 and .address.city == "Tokyo")' example.json

# 配列をマップ
jq '.users[] | {name, age}' example.json
jq '.users | map(.name)' example.json
jq '.users | map({Name: .name, Age: .age})' example.json

# 配列をソート
jq '.users | sort_by(.age)' example.json

# 配列の長さ
jq '.products | length' example.json
```


## 変換・更新

```bash
# 文字列結合
jq '.products[] | "Name: " + .name' example.json
jq '.products[] | "Name: \(.name), Stock: \(.stock)"' example.json

# 大文字変換
jq '.products[] | .name | ascii_upcase' example.json

# 値を更新(元のファイルには反映されない）
jq '.products[] | select(.name == "Keyboard") .stock += 1' example.json

# 元のファイルに更新を反映
tmp=$(mktemp) && jq '
    (.products[] | select(.name == "Keyboard")).stock += 1
' example.json > "$tmp" && mv "$tmp" example.json

# フィールド追加または更新
tmp=$(mktemp) && jq '
    (.products[] | select(.name == "Keyboard")).updated = (now | todate)
' example.json > "$tmp" && mv "$tmp" example.json

# ストック０で項目を削除
tmp=$(mktemp) && jq '
    del(.products[] | select(.stock <= 0))
' example.json > "$tmp" && mv "$tmp" example.json
```


## GitHub API

例として自分のリポジトリ`tomato-tom`の情報取得、ログイン不要な範囲で
```bash
# ユーザー情報を取得
curl -s https://api.github.com/users/tomato-tom |
  jq '{login, name, bio, public_repos, followers, following, created_at}'

# リポジトリ一覧
curl -s "https://api.github.com/users/tomato-tom/repos?per_page=100" |
  jq 'map({name, full_name, description, stargazers_count, forks_count, language, updated_at})'

# 最新のリポジトリ５件
curl -s "https://api.github.com/users/tomato-tom/repos?sort=updated&per_page=5" |
  jq -r '.[] | "\(.name) - \(.description // "No description")"'

```


## ログ分析

journalctlのJSON出力が個別のJSONオブジェクトで、改行区切りで出力されるため、`-s/-slurp`オプションなどでjqで扱えるようにする必要ある。

今回起動のログ統計
```sh
# __REALTIME_TIMESTAMP を数値に変換

journalctl -b --output=json | jq -s '
  map(.__REALTIME_TIMESTAMP |= tonumber) |
  {
    total_logs: length,
    unique_services: [.[] | ._SYSTEMD_UNIT // empty] | unique | length,
    time_range: {
      start: (min_by(.__REALTIME_TIMESTAMP).__REALTIME_TIMESTAMP / 1000000 | todate),
      end: (max_by(.__REALTIME_TIMESTAMP).__REALTIME_TIMESTAMP / 1000000 | todate)
    }
  }
'

# サービス別のログ数ランキング
journalctl -b --output=json | jq -s '
  [.[] | select(._SYSTEMD_UNIT != null)] | 
  group_by(._SYSTEMD_UNIT) | 
  map({unit: .[0]._SYSTEMD_UNIT, count: length}) | 
  sort_by(-.count) | 
  .[:10]
'

# 特定のサービス（dbus）のログを抽出
journalctl -b -u dbus.service --output=json | jq -s '
  map({
    timestamp: (.__REALTIME_TIMESTAMP | tonumber / 1000000 | todate),
    priority: .PRIORITY,
    message: .MESSAGE,
    unit: ._SYSTEMD_UNIT
  })
'

# 現在のエラーを確認（直近1時間）
journalctl --since "1 hour ago" --output=json | jq -s '
  [.[] | select(.PRIORITY <= 3)] | length'

# 既存のエラーを表示
journalctl -p err --output=json | jq -s '
  [.[] | {unit: ._SYSTEMD_UNIT, message: .MESSAGE}] | .[:5]'
```


## よく使う構文一覧

```
.              # 全体
.key           # キーアクセス
.[]            # 配列展開
.[index]       # 配列インデックス
.length        # 長さ
map(f)         # マッピング
select(f)      # フィルタリング
sort, sort_by  # ソート
group_by       # グループ化
max, min       # 最大値・最小値
add            # 合計
keys           # キー一覧
has(key)       # キーの存在確認
del(path)      # 削除
+ - * / %      # 演算
//             # デフォルト値
```

## マニュアル

jq --help
man jq

jq1.8 Manual
https://jqlang.org/manual/#invoking-jq

Wiki
https://github.com/jqlang/jq/wiki

