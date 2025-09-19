#!/bin/bash -e
# setup_dprint.sh
# markdownとかのフォーマッターdprintのセットアップ

PROJECT="/mnt/project"
PACKAGES=(
    iproute2
    iputils
    ping
    curl
    unzip
    vim
)

command -v "${packages[@]}" || {
    echo "📦 dprintをインストール..."
    apt update
    apt install -y "${packages[@]}"
}

command -v dprint || curl -fsSL https://dprint.dev/install.sh | sh

if ! grep -q "DPRINT_INSTALL" "$HOME/.profile"; then
    echo "⚙️ 環境変数を設定..."
    echo '' >> "$HOME/.profile"
    echo "# dprint" >> "$HOME/.profile"
    echo 'export DPRINT_INSTALL="/root/.dprint"' >> "$HOME/.profile"
    echo 'export PATH="$DPRINT_INSTALL/bin:$PATH"' >> "$HOME/.profile"
fi

source "$HOME/.profile"

[ -f "$PROJECT/dprint.json" ] || {
    [ -d "$PROJECT" ] || exit
    echo "🔧 設定ファイルを作成..."
    cat > "$PROJECT/dprint.json" << 'EOF'
{
  "markdown": {
    "lineWidth": 320
    "emphasisKind": "asterisks",
    "unorderedListKind": "dash",
  },
  "includes": ["*.md"],
  "plugins": [
    "https://plugins.dprint.dev/markdown-0.19.0.wasm"
  ]
}
EOF
}

