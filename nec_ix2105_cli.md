# NEC ix2105 CLI チートシート

AI書いたのだけどだいぶ違うかも、雰囲気はだいたいこれ
要確認、バージョンでも違う

## 基本操作

### モード移動
```
configure                       // グローバルコンフィグモードへ
enable-config                   // コンフィグモードへ
interface <interface-name>     // インターフェースコンフィグモードへ
exit                           // ログアウト
```

### システム基本設定
```
show version                   // システム情報表示
show running-config           // 現在の設定表示
show startup-config           // 起動設定表示
copy running-config startup-config  // 設定保存
reload                        // 再起動
clock set <HH:MM:SS> <YYYY/MM/DD>  // 日時設定
hostname <name>               // ホスト名設定
```

## インターフェース設定

### 基本設定
```
interface gigabitethernet 0/1  // ギガビットイーサネット設定
interface fastethernet 0/1     // ファストイーサネット設定
description <text>             // インターフェース説明
ip address <address> <mask>    // IPアドレス設定
no shutdown                   // インターフェース有効化
shutdown                      // インターフェース無効化
```

### 設定確認
```
show interfaces                 // 全インターフェース状態
show interface <interface-name> // 特定インターフェース詳細
show ip interface brief        // IPインターフェース概要
```

## ルーティング設定

### スタティックルート
```
ip route <network> <mask> <next-hop>  // スタティックルート追加
no ip route <network> <mask> <next-hop> // スタティックルート削除
```

### ルーティングプロトコル
```
router rip                     // RIP設定モード
 network <network>            // ネットワークアドバタイズ
 version 2                    // RIPバージョン2

router ospf <process-id>      // OSPF設定モード
 network <network> <mask> area <area-id>
```

### ルーティングテーブル確認
```
show ip route                  // ルーティングテーブル表示
show ip route <network>       // 特定ルート詳細
show ip protocols             // ルーティングプロトコル情報
```

## VLAN設定

### 基本VLAN設定
```
vlan <vlan-id>                 // VLAN作成/設定モード
 name <vlan-name>             // VLAN名設定
exit

interface vlan <vlan-id>       // VLANインターフェース設定
 ip address <address> <mask>
```

### トランキング/アクセス設定
```
interface gigabitethernet 0/1
 switchport mode trunk        // トランクポート設定
 switchport trunk allowed vlan <vlan-list>

 switchport mode access       // アクセスポート設定
 switchport access vlan <vlan-id>
```

### VLAN確認
```
show vlan                     // VLAN情報表示
show vlan id <vlan-id>       // 特定VLAN詳細
show interface switchport    // スイッチポート情報
```

## セキュリティ設定

### アクセス制御
```
enable secret <password>      // 特権パスワード設定
username <name> password <password>  // ユーザー作成

line console 0                // コンソール設定
 password <password>
 login

line vty 0 4                  // VTY（Telnet/SSH）設定
 password <password>
 login
```

### ACL設定
```
access-list <1-99> permit <source>  // 標準ACL作成
access-list <100-199> permit <protocol> <source> <destination>  // 拡張ACL

interface <interface-name>
 ip access-group <acl-number> in|out  // ACL適用
```

## その他便利コマンド

### デバッグ・確認
```
show logging                  // ログ表示
debug <feature>              // デバッグ開始
undebug all                  // 全デバッグ停止

ping <ip-address>            // pingテスト
traceroute <ip-address>      // トレースルート

show mac-address-table       // MACアドレステーブル表示
show arp                     // ARPテーブル表示
```

### 管理設定
```
ip default-gateway <address>  // デフォルトゲートウェイ設定
snmp-server community <string> ro|rw  // SNMPコミュニティ設定
logging host <ip-address>    // ログサーバー設定
```

