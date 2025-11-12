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
C-a d                # セッションからデタッチ
C-a \                # セッション停止
```
> tmuxのようなセッション間移動はない
> ウィンドウ間移動を軸に、セッション移動は一旦デタッチしてからということか

### window操作

```
C-a c    # 新しいウィンドウを作成
C-a n    # 次のウィンドウに移動
C-a p    # 前のウィンドウに移動
C-a 0-9  # ウィンドウ番号で直接移動
C-a "    # ウィンドウのリスト選択
C-a k    # 現在のウィンドウを終了
C-a A    # ウィンドウのタイトル変更
C-a ?    # ヘルプ表示
```

### リージョン操作

```
C-a |             # 垂直分割
C-a -             # 水平分割（custom）
C-a Tab           # 次のリージョンへ
C-a Shift-Tab     # 手前のリージョンへ
C-a C-a           # 前のリージョンと入れ替え
C-a X             # リージョン閉じる
```

### スクロール・コピー操作
```
C-a [    # スクロールモードに入る
Space    # コピー開始
Enter    # コピー終了
C-a ]    # ペースト
q        # スクロールモードを終了
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

### 複数ウィンドウでの作業例

```bash
# 編集用セッション
screen -S development

# 最初のウィンドウでエディタ開く
vim project.py

# 新しいウィンドウ（C-a c）でテスト実行
python project.py

# さらに新しいウィンドウでログ監視
tail -f app.log
```


## 設定例

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

