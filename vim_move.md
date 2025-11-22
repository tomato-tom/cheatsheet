---
title: Vim Moving cheatsheet
description: How to move around in a file using vim
updated: 2025-11-22
environment: ubuntu desktop
genai:
    - deepseek
visibility: public
status: wip
tags:
    - vim
    - move
    - cheatsheet
---
# Vim 移動系チートシート

### 基本移動
```
h, j, k, l    ← ↓ ↑ →（1文字ずつ）
w, W          次の単語の先頭へ
b, B          前の単語の先頭へ  
e, E          単語の末尾へ
0             行頭
^             行頭文字
$             行末
```
> 参照: `:help usr_03.txt`

### 行移動
```
gg            ファイルの先頭へ
G             ファイルの末尾へ
{line}G       指定行へ（例: 10G）
{line}gg      指定行へ
:line         指定行へ（例: :25）
```

### 画面移動
```
Ctrl-f        1画面下へ
Ctrl-b        1画面上へ
Ctrl-d        半画面下へ
Ctrl-u        半画面上へ
H             画面上部へ
M             画面中央へ
L             画面下部へ
zz            現在行を画面中央に
zt            現在行を画面上部に
zb            現在行を画面下部に
```
> 参照: `:help scroll.txt`

### 文字・パターン検索移動
```
f{keyword}    行内で文字を前方検索
F{keyword}    行内で文字を後方検索
t{keyword}    行内で文字の直前へ前方移動
T{keyword}    行内で文字の直後へ後方移動
;             最後のf/F/t/Tを繰り返し
,             最後のf/F/t/Tを逆方向に繰り返し
/{pattern}    前方検索
?{pattern}    後方検索
n             次の検索結果へ
N             前の検索結果へ
*             カーソル下の単語を前方検索
#             カーソル下の単語を後方検索
```
> 参照: `:help pattern.txt`

### ジャンプ移動
```
%             対応する括弧へ
[[            前の関数/セクションの開始
]]            次の関数/セクションの開始
{             前の空行（段落の境界）
}             次の空行（段落の境界）
(             前の文の開始
)             次の文の開始
Ctrl-o        前のジャンプ位置へ
Ctrl-i        次のジャンプ位置へ
```
> 参照: `:help jump-motions`

### マーク機能
```
m{word}       マークを設定（例: ma）
`{word}       マークへ移動（正確な位置）
'{word}       マークの行頭へ移動
``            直前のジャンプ位置へ
''            直前のジャンプ位置の行頭へ
```
> 参照: `:help mark-motions`

