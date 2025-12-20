---
title: vim search
description: Searching in files in vim
updated: 2025-12-20
genai:
    - claude sonnet4
    - deepseek
status: done
tags:
    - vim
    - search
    - cheatsheet
    - substitute
---
# vim 検索と置換

### 基本的な文字列検索
```
/           検索モードに入る、`<C-r>`で履歴遡る、`<C-n>`で進む
q/          検索履歴ウィンドウを開く
/foo        "foo"という文字列を検索
/^foo       行頭の"foo"を検索
/foo$       行末の"foo"を検索
/\<foo\>    単語単位でマッチ
```

### よく使うパターン (参照: `:help pattern`)
```
/foo\|bar       OR検索
/^\s*#          コメント行を検索（#で始まる）
/https\?://     URLを検索
/.*error.*      "error"を含む行全体をハイライト
```

### buffer内検索

```vim
:vimgrep /foo/ %       " 現在のバッファを検索
:copen                      " 検索結果のリスト
```

### 置換パターン(参照: `:help substitute`)

```
:%s/old/new/g            ファイル全体でoldをnewに置換
:s/old/new/g             現在行でoldをnewに置換
:'<,'>s/old/new/g        選択範囲でoldをnewに置換
:1,10s/old/new/g         1-10行でoldをnewに置換
:%s/old/new/gc           確認しながら置換
:%s//new/g               最後の検索パターンをnewに置換
```

### 行操作

```
:g/pattern/s/old/new/g   `pattern`を含む行のみで置換実行
:g/^$/d                  空行を削除
:%s/\n\n\+/\r\r/g        連続空行を詰める => 検索は`\n`、置換は`\r`
```
> `:g`(グローバルコマンド)

### 行頭・行末

```
:%s/^/  /            行頭にインデント（スペース2つ）挿入
:%s/$/;/             行末にセミコロン追加
:%s/^\s\+//          行頭の空白を削除
:%s/\s\+$//          行末の空白を削除
```

### 後方参照置き換え
```
:s/\(pattern\)/"\1"/            `pattern`を`"pattern"`のように囲む
:s/\(\w\+\)\s\+\(\w\+\)/\2 \1/   空白を挟む前後の文字列を入れ替え、例) one two -> two one
```
<--! 正規表現は程々にしないと人間の目につらい、AIなら大丈夫 -->


### 確認・元に戻し (参照: `:help undo`)
```
:%s/old/new/gn           マッチ数を確認（置換はしない）
u                        直前の置換を元に戻す
Ctrl-r                   元に戻したものをやり直し
```
