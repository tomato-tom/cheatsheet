---
title: systemd-run cheatsheet
description: Cheatsheet for systemd-run
created: 2025-09-19
environment: ubuntu desktop
genai:
    - claude sonnet4
    - deepseek
visibility: public
status: wip
tags:
    - systemd
    - transient
    - cheatsheet
---
# systemd-run チートシート

systemdの一時的サービス、スクリプトのバックグラウンド実行、リソース制限などに向いてそう

**要root権限**

## 基本構文
```bash
systemd-run [OPTIONS...] COMMAND [ARGS...]
```

<!-- status: checked | date: 2025-09-19 -->
### 基本的なサービス実行
```bash
# サービス実行されるが即終了して消滅
systemd-run echo hello

# ユニット名指定でバックグラウンド実行
systemd-run --unit=long-sleep sleep 100
systemctl status long-sleep.service

# 説明付き
systemd-run --unit=long-sleep --description="Long sleep" sleep 100

# フォアグラウンドで実行
systemd-run --wait sleep 8 && echo hello
```

<!-- status: checked | date: 2025-09-19 -->
### Scope（現在セッション内でフォアグラウンド実行）
```bash
# 現在の端末で実行
systemd-run --scope echo hello

# 制御構文を実行する場合は`bash -c`でラップするかスクリプト使う必要ある
systemd-run --scope bash -c 'for i in {1..10}; do echo hello && sleep 1; done'

# スクリプト実行
echo 'for i in {1..10}; do echo hello && sleep 1; done' >> /tmp/hello.sh
systemd-run --scope bash /tmp/hello.sh
```
<!-- 基本的にバックグラウンド実行で使うことが多そう。これ"--scope"使いみちあるのか？ -->

## トリガー実行

<!-- status: checked | date: 2025-09-19 -->
### Timer（時間ベース）
```bash
# 10秒後に実行
systemd-run --on-active=10s --unit=delayed bash -c 'echo "10 seconds passed" > /tmp/delayed.txt'

# 毎日2時に実行
systemd-run --on-calendar="*-*-* 02:00:00" --unit=daily-backup backup.sh

# 毎時実行（ランダム遅延）
echo date > /tmp/hourly-check.sh
systemd-run \
    --on-calendar=hourly \
    --timer-property=RandomizedDelaySec=10min \
    --unit=hourly-check \
    bash /tmp/hourly-check.sh
```

<!-- status: checked | date: 2025-09-19 -->
### Path（ファイル監視）
```bash
# ディレクトリの変更を監視し、変更があったらログ書き込み
systemd-run \
  --path-property="PathChanged=/tmp/mydir" \
  --path-property="MakeDirectory=yes" \
  --unit=my-monitor \
  bash -c 'date >> /tmp/my-monitor.log'
```

<!-- status: need-check | priority: low | reason: これはアプリ側でやる？
### Socket（ネットワーク監視）
```bash
# TCPポート監視
systemd-run --socket-property=ListenStream=8080 --unit=web-handler web-server

# UNIXソケット監視
systemd-run --socket-property=ListenStream=/run/api.sock --unit=api-handler api-server
```
-->

## リソース制御

<!-- status: checked | date: 2025-09-19 -->
### CPU制限
```bash
# CPU使用率を50%に制限
systemd-run --property=CPUQuota=50% --unit=cpu-limited cpu-intensive-task

# 特定CPUコアに制限
systemd-run --property=CPUAffinity=0-3 --unit=core-limited task
```

<!-- status: checked | date: 2025-09-19 -->
### メモリ制限
```bash
# メモリ使用量制限
systemd-run --property=MemoryMax=512M --unit=mem-limited memory-task

# スワップ無効
systemd-run --property=MemorySwapMax=0 --unit=no-swap task
```

<!-- status: need-check | priority: low
### 実行環境制御
```bash
# 環境変数設定
systemd-run --setenv=DEBUG=1 --setenv=PATH=/custom/bin:$PATH --unit=env-test app

# 作業ディレクトリ指定
systemd-run --working-directory=/tmp --unit=tmp-work task

# ユーザー指定
systemd-run --uid=1000 --gid=1000 --unit=user-task task
```
-->

## 実用的な使用例

<!-- status: need-check | priority: low | reason: たぶんいけそう、気が向いたら
### バックアップ・同期
```bash
# 自動rsync（ファイル変更時）
systemd-run --path-property=PathModified=/data --unit=auto-sync \
  --description="Auto sync data directory" \
  rsync -au /data/ backup-server:/backup/ &&
  rsync -au backup-server:/backup/ /data/ 

# 定期バックアップ（毎日2時、ランダム遅延）
systemd-run --timer --on-calendar="*-*-* 02:00:00" --property=RandomizedDelaySec=30min \
  --unit=daily-backup --description="Daily database backup" \
  pg_dump mydb | gzip > /backup/db-$(date +%Y%m%d).sql.gz
```

### システムメンテナンス
```bash
# 定期クリーンアップ（毎週月曜2時）
systemd-run --timer --on-calendar="Mon *-*-* 02:00:00" \
  --unit=weekly-cleanup --description="Weekly system cleanup" \
  /usr/local/bin/cleanup.sh

# ログローテーション（毎日）
systemd-run --timer --on-calendar=daily \
  --unit=log-rotation --description="Daily log rotation" \
  find /var/log -name "*.log" -mtime +7 -delete
```

### 開発・テスト
```bash
# リソース制限下でのテスト
systemd-run --scope --property=MemoryMax=100M --property=CPUQuota=25% \
  --description="Resource limited test" ./load-test

# 異なるユーザー権限でテスト
systemd-run --uid=nobody --working-directory=/tmp \
  --unit=security-test --description="Security permission test" ./test-script
```

### 監視・アラート
```bash
# ディスク使用量監視
systemd-run --timer --on-active=5m --on-unit-active=5m \
  --unit=disk-monitor --description="Disk usage monitor" \
  /usr/local/bin/check-disk-usage.sh

# サービス死活監視
systemd-run --timer --on-calendar="*:0/10" \
  --unit=health-check --description="Service health check" \
  /usr/local/bin/health-check.sh
```
-->

## 管理・確認コマンド

<!-- status: checked | date: 2025-09-19 -->
### ステータス確認
```bash
# 実行中のtransient(一時的)ユニット一覧
systemctl list-units --type=service | grep transient

# 特定ユニットの情報
systemctl status my-unit
systemctl show my-unit                # 特定ユニットの詳細情報
systemctl show -p MemoryMax my-unit   # 特定プロパティ情報

# ログ確認
journalctl -u my-unit -f

# リソース使用状況
systemd-cgtop
```

<!-- status: checked | date: 2025-09-19 -->
### 制御
```bash
# 停止
systemctl stop my-unit

# 全transientユニットの確認
systemctl list-units --all | grep transient

# 失敗してるサービスを確認
systemctl list-units --failed
systemctl is-failed [pattern...]

# failed`の場合は`reset-failed`でクリア、stopは効かない
# スクリプトに組み込む場合に重要
sudo systemctl reset-failed           # すべてのfailedサービスをリセット
sudo systemctl reset-failed <name>    # 個別にリセット
```

<!-- status: checked | date: 2025-09-19 -->
## よく使うプロパティ一覧
```bash
--property=CPUQuota=50%              # CPU使用率制限
--property=MemoryMax=1G              # メモリ上限
--property=RandomizedDelaySec=30min  # ランダム遅延
--property=User=nobody               # 実行ユーザー
--property=WorkingDirectory=/tmp     # 作業ディレクトリ
--setenv=VAR=value                   # 環境変数
--description="説明文"                # ユニット説明
```

