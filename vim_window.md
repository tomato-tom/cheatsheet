# Vim ウィンドウ操作

*便利なウィンドウ操作*
- 画面分割       <br>
- バッファ       <br>
- スクロール同期 <br>
- ターミナル     <br>
- ファイルエクスプローラ <br>
<br>

<div style="text-align: center;">
    <img src="vim_window.png" alt="vim_window" width="600">
</div>
<br>


## ホットキー

基本的に`Ctrl + w` のあとそれぞれのコマンドを続ける<br>
vim, nvim共通、詳細は`:help window`
<br>

### ウィンドウの分割

`C-w s` 上下分割                     <br>
`C-w v` 左右分割                     <br>
`C-w n` 新しいウィンドウで新規ファイル作成<br>
`C-w c` 現在のウィンドウを閉じる     <br>
`C-w o` 現在のウィンドウ以外を閉じる <br>
`C-w r` ウィンドウの入れ替え         <br>
<br>

### ウィンドウ間のカーソル移動

`C-w h/j/k/l` それぞれの方向へ移動<br>
`C-w w/p` 次/前のウィンドウへ移動<br>
`C-w W` 手前のウィンドウへ移動<br>
<br>

### ウィンドウの入れ替え

`C-w H/J/K/L` ウィンドウ入れ替え<br>
`C-w r/R` ウィンドウ入れ替えローテーション<br>
`C-w x` ウィンドウ入れ替え<br>
`C-w T` 現在のウィンドウを新規タブに移動<br>

<br>

### ウィンドウのサイズ

`C-w =` 均等<br>
`C-w +` １行広く<br>
`C-w -` １行狭く<br>
`C-w >` １文字広げる<br>
`C-w <` １文字狭く<br>
`C-w 11 >` 11文字広げる<br>
<br>


## コマンド

### コマンドでウィンドウ分割

`:sp` 水平分割<br>
`:vs` 垂直分割<br>
`:new` 水平分割で新規ファイル作成<br>
`:vnew` 垂直分割で新規ファイル作成<br>
`:clo` 現在のウィンドウを閉じる<br>
`:on` 他のウィンドウを閉じる<br>
`:vs script.js` `script.js`を左右分割で開く<br>
<br>

### バッファ

`vi *.md` 現在のディレクトリのマークダウンファイルを全部開く<br>
<br>
`:ls` バッファのリスト<br>
`:bn` 次のバッファ<br>
`:bp` 前のバッファ<br>
`:b3` ３番バッファに移動<br>
`:sbn` 次のバッファを分割表示<br>
`:ball` 全バッファを分割表示<br>

> `:help buffer-list` マニュアル
<br>


### スクロール同期

`vi -O file1 file2` 複数のファイルを垂直分割で開く<br>
<br>
`:set scb` スクロール同期<br>
`:set noscb` スクロール同期解除<br>
`:windo set scb` すべてのウィンドウでスクロール同期<br>

> `:help scrollbind` マニュアル

翻訳するとき原文と翻訳文を同期すると便利
<br>


### ターミナル

`:term` ターミナル開く<br>
`:vert term` 左にターミナル開く<br>
<br>

> `:help terminal` マニュアル<br>
> 環境次第で挙動変わる


### ファイルエクスプローラ

`:E` 開く<br>
`:S` 上に開く<br>
`:Ve` 左に開く<br>

ファイル/ディレクトリにカーソル移動して

`Enter` 開く<br>
`-` 親ディレクトリに移動<br>
<br>
> `:help explore` マニュアル

