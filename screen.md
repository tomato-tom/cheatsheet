---
title: Screen
description: Screen cheatsheet
created: 2025-11-12
update: 2025-11-22
visibility: public
status: done
tags:
    - cheatsheet
    - screen
    - console
    - terminal
    - cli
---
# screen

screenは非常に便利な端末マルチプレクサです。

### セッションの開始・管理
```
screen                        # 新しいセッション開始
screen -S <name>              # 名前指定でセッションを開始
screen -t <file> vim file.md  # 特定のコマンドでウィンドウを開始
screen -r <name>              # デタッチしたセッションに再接続
screen -ls                    # セッション一覧表示
screen -S <name> -X quit      # セッション指定で停止
pkill screen                  # 全セッション停止

# セッション中
`C-a d`    # セッションからデタッチ
`C-a \`    # セッション停止
`C-a ?`    # ヘルプ表示
```
> tmuxのようなセッション間移動はない?
> ウィンドウ間移動を軸に、セッション移動は一旦デタッチしてからということか

### window操作

```
`C-a c`    # 新しいウィンドウを作成
`C-a n`    # 次のウィンドウに移動
`C-a p`    # 前のウィンドウに移動
`C-a 0-9`  # ウィンドウ番号で直接移動
`C-a "`    # ウィンドウのリスト選択
`C-a k`    # 現在のウィンドウを終了
`C-a A`    # ウィンドウのタイトル変更
```

### リージョン操作

```
`C-a |`             # 垂直分割
`C-a -`             # 水平分割（default: S）
`C-a Tab`           # 次のリージョンへ
`C-a C-a`           # 前のリージョンと入れ替え
`C-a X`             # リージョン閉じる
```

### スクロール・コピー操作
```
`C-a [`    # スクロールモードに入る
`Space`    # コピー開始
`Enter`    # コピー終了
`C-a ]`    # ペースト
`q`        # スクロールモードを終了
```
> コピーモードではviキーバインド


### サーバー作業例

```bash
# サーバーにログイン後、セッションを開始
screen -S work

# 長時間実行されるスクリプトを実行
./long_running.sh

# 一旦デタッチ
C-a d

# 後で再接続して確認
screen -r work

セッション終了
C-a \
```

### ネットワーク機器接続例

```bash
# 接続ポート確認
ls -l /dev/ttyUSB*

# シリアルコンソール接続
screen /dev/ttyUSB0 9600
```


### 設定例

~/.screenrc
```
# UTF-8サポート
defutf8 on

# 大きなスクロールバッファ
defscrollback 10000

# スタートアップメッセージを無効化
startup_message off

# ステータスライン
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W} %c %{g}]'
```

### ヘルプ

`C-a ?`でヘルプ表示
```
                              Command key:  ^A   Literal ^A:  a

break       ^B b       history     { }        other       ^A         split       S
clear       C          info        i          pow_break   B          suspend     ^Z z
colon       :          kill        K k        pow_detach  D          time        ^T t
copy        ^[ [       lastmsg     ^M m       prev        ^H ^P p ^? title       A
detach      ^D d       license     ,          quit        \          vbell       ^G
digraph     ^V         lockscreen  ^X x       readbuf     <          version     v
displays    *          log         H          redisplay   ^L l       width       W
dumptermcap .          login       L          remove      X          windows     ^W w
fit         F          meta        a          removebuf   =          wrap        ^R r
flow        ^F f       monitor     M          reset       Z          writebuf    >
focus       ^I         next        ^@ ^N sp n screen      ^C c       xoff        ^S s
hardcopy    h          number      N          select      '          xon         ^Q q
help        ?          only        Q          silence     _

^]   paste .
"    windowlist -b
-    select -
0    select 0
1    select 1
2    select 2
3    select 3
4    select 4
5    select 5
6    select 6
7    select 7
8    select 8
9    select 9
I    login on
O    login off
]    paste .
|    split -v
:kB: focus prev
```

