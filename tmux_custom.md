---
title: Custom tmux cheatsheet
description: A tmux cheat sheet for my personal custom settings
updated: 2025-09-19
environment: ubuntu desktop
genai:
    - deepseek
visibility: public
status: done
tags:
    - tmux
    - cheatsheet
---
# tmux チートシート(カスタム)

## 基本操作

```bash
tmux                         # 新しいセッションの開始
tmux ls                      # セッションリストの表示
tmux attach                  # 切り離したセッションに再接続
tmux new-session -s <name>   # 新しいセッションを指定した名前で開始
tmux new-session -d          # 新しいセッションをバックグラウンドで開始
tmux attach -t <name>        # 指定したセッションに再接続
tmux kill-session -t <name>  # 指定したセッションを終了
tmux kill-session -a         # 接続してるセッション以外を終了
```

- `C-b d`：現在のセッションからデタッチ（セッションをバックグラウンドに移動）

## セッション操作

```
C-b )      次のセッションに移動
C-b (      前のセッションに移動
C-b $      セッション名を変更
C-b L      以前のセッションに移動
C-b s      セッションのリストから選択して移動
```

## ウィンドウ操作

```
C-b c      新しいウィンドウを作成(現在のパスで)
C-b n      次のウィンドウに切り替え
C-b p      前のウィンドウに切り替え
C-b w      ウィンドウの一覧を表示して選択
C-b &      現在のウィンドウを閉じる
C-b ,      ウィンドウ名を変更
```

## ペイン操作
```
# 分割
C-b -          水平にペインを分割(default: ")
C-b |          垂直にペインを分割(default: %)
C-b 3          ３分割
C-b 4          ４分割
C-b x          現在のペインを閉じる

# 移動
C-b h/j/k/l    vim風ペイン移動
C-b ;          以前作業したペインに移動
C-b o          次のペインに移動

# 入れ替え
C-b C-o        ペインの順序を入れ替え
C-b >          ペインの入れ替え
C-b <          ペインの入れ替え

# サイズ変更
C-b H/J/K/L    ペインのサイズを5文字単位で調整（vim風、リピート可能）
C-b C-arrow    ペインのサイズを1文字単位で調整
C-b m          ペインの最大化/元に戻す
C-b =          ペインを均等サイズに even-horizontal
C-b +          ペインを均等サイズに even-vertical

# その他
C-b !          現在のペインを新しいウィンドウに移動
C-b S          ペインの同期切り替え（全ペインに同じコマンドを送信）
```

## その他の操作

```
C-b r     設定を適用
C-b ?     キーバインディングの一覧を表示
C-b [     コピーモードに入る
            * viのような操作でスクロールやテキスト選択が可能
C-b ]     コピーモードで選択したテキストをペースト
C-b z     現在のペインを最大化/元に戻す
C-b t     時計を表示
C-b q     ペイン番号を表示
```


## 設定ファイル

`~/.tmux.conf`
> 例: https://github.com/tomato-tom/ubuntu-setup/blob/main/dotfiles/tmux.conf

## エイリアス

```
tl           リスト
tn [name]    新しいセッションを作成、既存ならあタッチ
ta [name]    セッションにアタッチ
tk <name>    セッションを削除、引数なしですべてのセッションを終了
```
> 例: https://github.com/tomato-tom/ubuntu-setup/blob/main/dotfiles/bashrc

