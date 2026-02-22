---
title: AWK
description: Basic AWK cheat sheat 
updated: 2026-02-22
genai:
    - deepseek
visibility: public
status: draft
tags:
    - awk
---
# AWKチートシート

### 基本構文
```bash
awk 'pattern { <action> }' <file>
awk '条件式 { <command> }' <file>
```

### 実行方法
```bash
awk '<command>' <data>           # 基本形
awk -f <program> <data>          # fileからprogram読み込み
awk '{print}' <file>             # file内容を全て表示
command | awk '<command>'        # パイプ入力
```

### 特殊パターン
```bash
BEGIN { <action> }    # 最初に1回だけ実行
END { <action> }      # 最後に1回だけ実行
```

### 組み込み変数
| 変数        | 説明                                         |
|-------------|----------------------------------------------|
| `$0`        | レコード全体（通常は1行全体）                |
| `$1, $2...` | 各フィールド（列）                           |
| `NF`        | フィールド数（Number of Fields）             |
| `NR`        | 現在のレコード番号（行番号）                 |
| `FNR`       | 現在のファイルでのレコード番号               |
| `FS`        | フィールド区切り文字（デフォルト：空白）     |
| `OFS`       | 出力フィールド区切り文字（デフォルト：空白） |
| `RS`        | レコード区切り文字（デフォルト：改行）       |
| `ORS`       | 出力レコード区切り文字（デフォルト：改行）   |
| `FILENAME`  | 現在入力中のファイル名                       |

### 基本操作

列抽出
```bash
awk '{print $1}' <file>            # 1列目を表示
awk '{print $1, $3}' <file>        # 1列目と3列目を表示
awk '{print $NF}' <file>           # 最後の列を表示
awk '{print $(NF-1)}' <file>       # 最後から2番目の列
```

行選択
```bash
awk '/pattern/' <file>              # 条件に合う行を表示
awk '/error/ {print $1}' <file>     # errorを含む行の1列目
awk '!/error/' <file>               # errorを含まない行
awk '$1 ~ /^A/' <file>              # 1列目がAで始まる行
awk '$1 !~ /^A/' <file>             # 1列目がAで始まらない行
```

条件指定
```bash
awk '$3 > 100' <file>               # 3列目が100より大きい行
awk '$3 > 100 && $3 < 200' <file>   # 3列目が100〜200の行
awk '$1 == "apple"' <file>          # 1列目がappleの行
awk 'NR >= 5 && NR <= 10' <file>    # 5行目から10行目まで
```

### 出力整形

printf書式
```bash
awk '{printf "%-10s %5d\n", $1, $2}' <file>   # 左寄せ10桁、右寄せ5桁
awk '{printf "%.2f\n", $3}' <file>            # 小数第2位まで
```

列区切り変更
```bash
awk -F: '{print $1}' /etc/passwd     # コロン区切り（:）
awk -F'\t' '{print $2}' <file>       # タブ区切り
awk -F'[ ,]' '{print $2}' <file>     # 空白またはカンマ区切り
```

### 組込関数

文字列操作
```bash
length($0)              # 文字数
index(<str>, <sub>)     # 部分文字列の位置
substr($1, 2, 3)        # 2文字目から3文字取得
tolower($1)             # 小文字化
toupper($1)             # 大文字化
gsub(/old/, "new", $1)  # 全置換
sub(/old/, "new", $1)   # 最初のみ置換
split($1, <arr>, ":")     # 分割して配列に格納
```

数値関数
```bash
int(x)          # 整数化
sqrt(x)         # 平方根
rand()          # 乱数（0〜1）
srand()         # 乱数初期化
```

### 配列
```bash
# 連想配列
awk '{count[$1]++} END {for (item in count) print item, count[item]}' <file>

# 多次元配列風
awk '{data[$1,$2] = $3} END {print data["apple","red"]}'
```

### 集計
```bash
awk '{sum += $2} END {print "合計:", sum}' <file>                    # 合計
awk '{sum += $2; count++} END {print "平均:", sum/count}' <file>     # 平均
awk 'NR>1 {if ($2 > max) {max=$2; line=$0}} END {print line}' <file> # 最大値の行
```

### 実用例

CSV処理
```bash
awk -F, 'NR>1 {print $1, $3}' data.csv                    # 見出し行を除外
awk -F, '$4 ~ /^2024/ {sum += $5} END {print sum}' data.csv  # 条件付き集計
```

文字列処理
```bash
awk '{gsub(/[0-9]+/, "NUM", $0); print}' <file>    # 数字をNUMに置換
awk '{print NR ":" $0}' <file>                      # 行番号付きで表示
awk '!seen[$0]++' <file>                            # 重複行を削除
```

複数ファイル処理
```bash
awk 'FNR==1 {print "---", FILENAME, "---"}; {print}' <file1> <file2>
```

### 1行コマンド
```bash
# 特定の列の合計
awk '{sum+=$2} END {print sum}' data.txt

# 平均
awk '{sum+=$2} END {print sum/NR}' data.txt

# 最大値の行
awk 'max < $2 {max=$2; line=$0} END {print line}' data.txt

# 列の抽出と並替
awk '{print $3, $1}' data.txt | sort

# 条件に合う行の数
awk '/error/ {count++} END {print count}' log.txt

# 列で集約
awk '{a[$1] += $2} END {for (i in a) print i, a[i]}' data.txt

# ４列目から行末まで
awk '{for(i=4; i<=NF; i++) printf "%s ", $i; print ""}' app.log
```

### 注意点
- アクションは `{}` で囲む
- 複数コマンドは `;` で区切る
- 変数は初期化不要（数値は0、文字列は空）
- パターン省略時は全ての行が対象
- アクション省略時は `{print}` とみなす
