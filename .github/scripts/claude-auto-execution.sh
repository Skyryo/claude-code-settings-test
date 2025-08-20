#!/bin/bash

# Claude Code 自動実装スクリプト
# このスクリプトは設定ファイルを読み込み、条件に応じてClaude Codeの実行を制御します

set -e

CONFIG_FILE=".github/claude-config.yml"
ISSUE_NUMBER=${1:-$GITHUB_EVENT_ISSUE_NUMBER}
ISSUE_BODY=${2:-$GITHUB_EVENT_ISSUE_BODY}
ISSUE_TITLE=${3:-$GITHUB_EVENT_ISSUE_TITLE}
ISSUE_LABELS=${4:-$GITHUB_EVENT_ISSUE_LABELS}

# ログ関数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# エラーハンドリング
error_exit() {
    log "ERROR: $1"
    exit 1
}

# 設定ファイルの存在確認
if [[ ! -f "$CONFIG_FILE" ]]; then
    log "WARNING: 設定ファイル $CONFIG_FILE が見つかりません。デフォルト設定を使用します。"
    CONFIG_FILE=""
fi

# YAML設定読み込み（簡易版 - yqが利用可能な場合）
read_config() {
    local key="$1"
    local default="$2"
    
    if [[ -f "$CONFIG_FILE" ]] && command -v yq &> /dev/null; then
        yq eval "$key" "$CONFIG_FILE" 2>/dev/null || echo "$default"
    else
        echo "$default"
    fi
}

# 自動実行可否の判定
should_auto_execute() {
    local auto_enabled=$(read_config ".auto_execution.enabled" "true")
    
    if [[ "$auto_enabled" != "true" ]]; then
        log "自動実行が無効になっています"
        return 1
    fi
    
    # スキップラベルのチェック
    local skip_labels=$(read_config ".auto_execution.skip_labels[]" "")
    if [[ -n "$skip_labels" && -n "$ISSUE_LABELS" ]]; then
        for label in $skip_labels; do
            if echo "$ISSUE_LABELS" | grep -q "$label"; then
                log "スキップラベル '$label' が検出されました。自動実行をスキップします。"
                return 1
            fi
        done
    fi
    
    return 0
}

# メイン処理
main() {
    log "Claude Code 自動実装スクリプトを開始します"
    log "Issue #$ISSUE_NUMBER: $ISSUE_TITLE"
    
    # 自動実行可否判定
    if ! should_auto_execute; then
        log "自動実行条件を満たしていません。処理を終了します。"
        exit 0
    fi
    
    log "自動実行条件を満たしています。Claude Code を実行します。"
    
    # カスタム指示の読み込み
    local custom_instructions=$(read_config ".claude_behavior.custom_instructions" "")
    
    # 実行統計の記録
    local collect_metrics=$(read_config ".debug.collect_metrics" "true")
    if [[ "$collect_metrics" == "true" ]]; then
        log "実行統計: Issue #$ISSUE_NUMBER の自動処理を開始"
        echo "CLAUDE_EXECUTION_START=$(date -u +%s)" >> "$GITHUB_ENV"
    fi
    
    # Claude Code の実行はGitHub Actionsのstepで行われるため、
    # ここでは前処理と環境設定のみ実行
    echo "CLAUDE_AUTO_EXECUTION=true" >> "$GITHUB_ENV"
    echo "CLAUDE_ISSUE_NUMBER=$ISSUE_NUMBER" >> "$GITHUB_ENV"
    
    if [[ -n "$custom_instructions" ]]; then
        echo "CLAUDE_CUSTOM_INSTRUCTIONS<<EOF" >> "$GITHUB_ENV"
        echo "$custom_instructions" >> "$GITHUB_ENV"
        echo "EOF" >> "$GITHUB_ENV"
    fi
    
    log "前処理が完了しました。Claude Code の実行準備が整いました。"
}

# スクリプト実行
main "$@"