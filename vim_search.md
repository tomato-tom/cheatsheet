---
title: vim search
description: Searching in files in vim
updated: 2025-12-12
environment: ubuntu desktop
genai:
    - claude sonnet4
    - deepseek
visibility: public
status: wip
tags:
    - vim
    - search
    - cheatsheet
    - substitute
---

# vim 検索と置換のチートシート

### 基本的な文字列検索
```
/function        "function"という文字列を検索
/^function       行頭の"function"を検索
/function$       行末の"function"を検索
/\<function\>    完全一致で"function"を検索（functionaryなどは除外）
```

### buffer内検索

```vim
:vimgrep /パターン/ %       " 現在のバッファのみ
:copen                      " 検索結果のリスト
```

### プログラミングでよく使うパターン (参照: `:help pattern`)
```
/function\s\+\w\+   function で始まる関数定義を検索（JavaScript等）
/TODO\|FIXME        TODOかFIXMEを検索
/^\s*#              コメント行を検索（#で始まる）
```

### 空行・空白関連 (参照: `:help /\s`)
```
/^$          空行を検索
/^\s*$       空白のみの行を検索
/\s\+$       行末の空白を検索
/\t          タブ文字を検索
/  \+        連続するスペースを検索
```

### 数値・記号パターン (参照: `:help /\d`)
```
/\d\+        数字を検索
/\d\{4}      4桁の数字を検索（年など）
/\d\+\.\d\+  小数点数を検索
/[0-9a-fA-F]\{8} 8桁の16進数を検索
/\w\+@\w\+\.\w\+ 簡単なメールアドレス検索
```

### ファイル形式別パターン
```
# HTML/XML
/<[^>]*>     タグを検索
/<\/\w\+>    終了タグを検索

# JSON
/"[^"]*":    JSONキーを検索
/\[\|\]      配列の開始・終了を検索

# URL・パス
/https\?://  URLを検索
/\/[^/]*\/   パス区切りを検索
```

### 大文字小文字の制御 (参照: `:help 'ignorecase'`)
```
/pattern     通常検索（設定による）
/\cpattern   大文字小文字を無視
/\Cpattern   大文字小文字を区別
```

### 便利な検索テクニック
```
/.*error.*   "error"を含む行全体をハイライト
/\v(TODO|FIXME|XXX)  very magic モードで複数キーワード
/\%>10l\%<20lpattern  10-20行の範囲でpatternを検索
/\%23cpattern  23列目のpatternを検索
```

### 検索履歴の活用 (参照: `:help search-history`)
```
/            検索モードに入る
↑↓          検索履歴を辿る
q/           検索履歴ウィンドウを開く
```


## Vim 置換パターン

### 基本的な置換 (参照: `:help substitute`)
```
:%s/old/new/g        ファイル全体でoldをnewに置換
:s/old/new/g         現在行でoldをnewに置換
:'<,'>s/old/new/g    選択範囲でoldをnewに置換
:1,10s/old/new/g     1-10行でoldをnewに置換
:%s/old/new/gc       確認しながら置換
:%s/old/new/gi       大文字小文字を無視して置換
```

### 空白・改行の整理 (参照: `:help /\s`)
```
:%s/\s\+$//g         行末の空白を削除
:%s/\t/    /g        タブを4つのスペースに変換
:%s/    /\t/g        4つのスペースをタブに変換
:%s/\n\n\+/\r\r/g    3つ以上の改行を2つに統一
:%s/\r//g            Windows改行コード(CR)を削除
:%s/ \+/ /g          連続するスペースを1つに統一
```

### プログラミングでよく使うパターン
```
# 変数名・関数名の変更
:%s/\<oldVar\>/newVar/g        完全一致で変数名変更
:%s/\<get\(\w\+\)\>/fetch\1/g  getXxxをfetchXxxに変更

# コメントの変更
:%s/^#/\/\//g                  #コメントを//コメントに変更
:%s/^\/\*\(.*\)\*\/$/# \1/g    /* */ を # に変更

# クォートの変更
:%s/'/"/g                      シングルクォートをダブルクォートに
:%s/"\([^"]*\)"/'\1'/g         ダブルクォートをシングルクォートに
```

### HTMLタグ操作 (参照: `:help non-greedy`)
```
:%s/<b>\(.\{-}\)<\/b>/<strong>\1<\/strong>/g  <b>を<strong>に
:%s/<[^>]*>//g                              全てのHTMLタグを削除
:%s/&lt;/</g                               HTMLエンティティをデコード
:%s/</\&lt;/g                              <をHTMLエンティティに
```

### 行の操作・整形
```
:%s/^/    /g             各行の先頭に4つのスペースを追加
:%s/^    //g             各行の先頭から4つのスペースを削除  
:%s/^/#/g                各行の先頭に#を追加
:%s/$/;/g                各行の末尾に;を追加
:%s/\(.*\)/"\1",/g       各行を"で囲んで末尾に,を追加
:%s/^\s*\d\+\.\s*//g     行頭の番号付けを削除
```

### ファイル形式別
```
# JSON整形
:%s/",/",\r/g            JSONで改行を入れる
:%s/:\([^,}]\+\)/: \1/g  JSONでコロン後にスペース追加

# SQL整形
:%s/,/,\r    /g          SQLのSELECT文で改行
:%s/\<AND\>/\r  AND/g    AND句で改行

# ログファイル整理
:%s/ERROR\|WARN/*** \0 ***/g  エラーとワーニングを強調
```

### 便利なテクニック
```
:%s//new/g               最後の検索パターンをnewに置換
:%s/pattern/\=@a/g       レジスタaの内容で置換
:%s/\n/\r/g              改行コードの統一
:g/pattern/s/old/new/g   patternを含む行のみで置換実行
:%s/\%V/prefix/g         ビジュアル選択範囲の各行頭にprefixを追加
```

### 確認・元に戻し (参照: `:help undo`)
```
:%s/old/new/gn           マッチ数を確認（置換はしない）
:%s/old/new/gc           1つずつ確認しながら置換
u                        直前の置換を元に戻す
Ctrl-r                   元に戻したものをやり直し
```

