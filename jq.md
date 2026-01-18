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

動作確認に使用したファイル
example.json

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


## 文字列操作
```bash
# 文字列結合
jq '.products[] | "Name: " + .name' example.json
jq '.products[] | "Name: \(.name), Stock: \(.stock)"' example.json

# 大文字変換
jq '.products[] | .name | ascii_upcase' example.json
```


# 条件分岐
```
jq '.users[] | if .age > 30 then "adult" else "minor" end' example.json

```

## GitHub API

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
<!-- confirmed up to this line -->


例2: ログファイルの分析
```json
[
  {"timestamp": "2024-01-01", "level": "ERROR", "message": "Failed to connect"},
  {"timestamp": "2024-01-01", "level": "INFO", "message": "Connected"},
  {"timestamp": "2024-01-02", "level": "ERROR", "message": "Timeout"}
]
```
```bash
# ERRORのみ抽出
jq '.[] | select(.level == "ERROR")' logs.json

# 日付ごとのエラー数を集計
jq '[.[] | select(.level == "ERROR")] | group_by(.timestamp) | map({date: .[0].timestamp, count: length})' logs.json
```

例3: 設定ファイルの編集
```bash
# 設定ファイルの特定の値を更新
jq '.debug = true' config.json > config_new.json

# ネストした値を更新
jq '.database.host = "localhost"' config.json
```

## 便利なオプション
```bash
# コンパクトな出力
jq -c '.' example.json

# 生の文字列として出力（クォートなし）
jq -r '.name' example.json

# デフォルト値の設定
jq '.name // "default"' example.json

# 入力ファイルを直接編集（-iオプション）
jq -i '.enabled = true' config.json
```

## 複数ファイルの処理
```bash
# 複数ファイルを配列として結合
jq -s '.' file1.json file2.json

# 複数ファイルを個別に処理
jq '.key' *.json
```

## コマンド一覧

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


