# systemd-run チートシート

## 基本構文
```bash
systemd-run [OPTIONS...] COMMAND [ARGS...]
```

## 基本的な実行

### Service（バックグラウンド実行）
```bash
# 基本実行
systemd-run echo "hello world"

# ユニット名指定
systemd-run --unit=my-job echo "hello"

# 説明付き（重要！）
systemd-run --unit=backup --description="Daily backup job" backup.sh

# フォアグラウンドで実行（出力を直接見る）
systemd-run --wait echo "immediate output"
```

### Scope（現在セッション内で実行）
```bash
# 現在の端末で実行、systemdが監視
systemd-run --scope echo "hello"

# リソース制限付きで実行
systemd-run --scope --property=MemoryMax=1G memory-intensive-app
```

## トリガー実行

### Timer（時間ベース）
```bash
# 10秒後に実行
systemd-run --timer --on-active=10s --unit=delayed echo "10 seconds passed"

# 毎日2時に実行
systemd-run --timer --on-calendar="*-*-* 02:00:00" --unit=daily-backup backup.sh

# 毎時実行（ランダム遅延付き）
systemd-run --timer --on-calendar=hourly --property=RandomizedDelaySec=10min --unit=hourly-check check.sh

# 相対時間指定
systemd-run --timer --on-active=5m --unit=reminder notify.sh
```

### Path（ファイル監視）
```bash
# ファイル変更監視
systemd-run --path --path-property=PathModified=/var/log/app.log --unit=log-watcher process-log.sh

# ファイル作成監視
systemd-run --path --path-property=PathExists=/tmp/trigger --unit=file-handler handle-file.sh

# ディレクトリ内のパターンマッチ
systemd-run --path --path-property=PathExistsGlob=/upload/*.jpg --unit=photo-sync sync-photos.sh
```

### Socket（ネットワーク監視）
```bash
# TCPポート監視
systemd-run --socket --socket-property=ListenStream=8080 --unit=web-handler web-server

# UNIXソケット監視
systemd-run --socket --socket-property=ListenStream=/run/api.sock --unit=api-handler api-server
```

## リソース制御

### CPU制限
```bash
# CPU使用率を50%に制限
systemd-run --property=CPUQuota=50% --unit=cpu-limited cpu-intensive-task

# 特定CPUコアに制限
systemd-run --property=CPUAffinity=0-3 --unit=core-limited task
```

### メモリ制限
```bash
# メモリ使用量制限
systemd-run --property=MemoryMax=512M --unit=mem-limited memory-task

# スワップ無効
systemd-run --property=MemorySwapMax=0 --unit=no-swap task
```

### 実行環境制御
```bash
# 環境変数設定
systemd-run --setenv=DEBUG=1 --setenv=PATH=/custom/bin:$PATH --unit=env-test app

# 作業ディレクトリ指定
systemd-run --working-directory=/tmp --unit=tmp-work task

# ユーザー指定
systemd-run --uid=1000 --gid=1000 --unit=user-task task
```

## 実用的な使用例

### バックアップ・同期
```bash
# 自動rsync（ファイル変更時）
systemd-run --path --path-property=PathModified=/data --unit=auto-sync \
  --description="Auto sync data directory" \
  rsync -av /data/ backup-server:/backup/

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

## 管理・確認コマンド

### ステータス確認
```bash
# 実行中のtransientユニット一覧
systemctl list-units --type=service | grep transient

# 特定ユニットの詳細
systemctl status my-unit

# ログ確認
journalctl -u my-unit -f

# リソース使用状況
systemd-cgtop
```

### 制御
```bash
# 停止
systemctl stop my-unit

# 強制終了
systemctl kill my-unit

# 全transientユニットの確認
systemctl list-units --all | grep transient
```

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

## Tips
- 必ず `--description` を付ける（運用時に重要）
- 本番環境では `RandomizedDelaySec` で負荷分散
- リソース制限は安全のために積極的に使う
- ログは `journalctl -u ユニット名` で確認
- transientユニットは再起動で消える（永続化不要）
