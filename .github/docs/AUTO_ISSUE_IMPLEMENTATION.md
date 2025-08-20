# Claude Code 自動Issue実装システム

このドキュメントは、新しいissueが作成された際に自動でClaude Codeによるコード実装を開始するシステムの使用方法と設定について説明します。

## 概要

このシステムにより、以下の機能が提供されます：

- **自動トリガー**: 新しいissueが作成されると自動的にClaude Codeが起動
- **セキュアな認証**: GitHub Secretsによる安全なAPIキー管理
- **柔軟な設定**: ラベルベースの実行制御と詳細な設定オプション
- **エラーハンドリング**: 失敗時の自動通知とフォールバック
- **拡張性**: 将来的な他のAIツール連携を考慮した設計

## セットアップ

### 1. 必要なシークレットの設定

GitHub リポジトリの Settings > Secrets and variables > Actions で以下のシークレットを設定：

```
CLAUDE_CODE_OAUTH_TOKEN=your_claude_code_oauth_token_here
```

### 2. ワークフローファイルの確認

`.github/workflows/claude.yml` が正しく配置されていることを確認してください。

### 3. 設定ファイルのカスタマイズ（オプション）

`.github/claude-config.yml` を編集して、システムの動作をカスタマイズできます。

## 使用方法

### 基本的な使用方法

1. **新しいissueを作成**: リポジトリで新しいissueを作成すると、自動的にClaude Codeが起動します
2. **進捗の確認**: GitHub Actionsのタブで実行状況を確認できます
3. **結果の確認**: 完了後、issueにコメントが自動投稿され、PRが作成される場合があります

### ラベルによる制御

特定のラベルを使用してシステムの動作を制御できます：

#### 自動実行をスキップするラベル
- `manual-only`: 手動実行のみ
- `no-automation`: 自動化を無効
- `discussion`: 議論用（実装不要）
- `question`: 質問（実装不要）

#### 自動実行を強制するラベル
- `auto-implement`: 強制的に自動実行
- `bug`: バグ修正
- `enhancement`: 機能強化

### 手動実行

自動実行が無効になっている場合や、追加の作業が必要な場合は、issueのコメントで `@claude` とメンションすることで手動実行できます。

## 設定オプション

### `.github/claude-config.yml` の主要設定

```yaml
# 自動実行の有効/無効
auto_execution:
  enabled: true

# 使用するClaude モデル
claude_behavior:
  model: "claude-3-5-sonnet"

# カスタム指示
claude_behavior:
  custom_instructions: |
    プロジェクト固有の実装ガイドライン...

# 通知設定
notifications:
  success_message_template: |
    カスタム成功メッセージ...
```

詳細な設定オプションについては、`.github/claude-config.yml` のコメントを参照してください。

## トラブルシューティング

### よくある問題と解決方法

1. **Claude Codeが起動しない**
   - CLAUDE_CODE_OAUTH_TOKEN が正しく設定されているか確認
   - issueにスキップラベルが付いていないか確認
   - GitHub Actions の権限設定を確認

2. **エラーメッセージが表示される**
   - GitHub Actions の実行ログを確認
   - エラーメッセージに記載された対処法を実行
   - 必要に応じて `@claude` で手動実行を試行

3. **期待した実装が生成されない**
   - issueの説明をより詳細に記述
   - 要件や制約を明確に記載
   - カスタム指示の設定を調整

### ログとデバッグ

- **実行ログ**: GitHub Actions の "Run Claude Code" ステップでClaude Codeの詳細ログを確認
- **デバッグモード**: `.github/claude-config.yml` で `debug.log_level: "debug"` に設定
- **統計情報**: `debug.collect_metrics: true` で実行統計を記録

## セキュリティ考慮事項

1. **シークレット管理**: 
   - APIキーは必ずGitHub Secretsで管理
   - ログにシークレット情報が出力されないよう注意

2. **権限制御**:
   - ワークフローは最小限の権限で実行
   - 必要に応じて権限を追加調整

3. **コード検証**:
   - 生成されたコードは必ずレビューを実施
   - セキュリティ脆弱性がないか確認

## 拡張とカスタマイズ

### 他のAIツールとの連携

将来的に他のAIツール（例：GitHub Copilot、ChatGPT API）との連携も可能です：

```yaml
extensions:
  ai_tools:
    - name: "claude-code"
      enabled: true
      priority: 1
    - name: "other-ai-tool"
      enabled: false
      priority: 2
```

### カスタムフック

前処理・後処理のカスタマイズが可能です：

```yaml
extensions:
  hooks:
    pre_execution:
      - name: "custom_validation"
        script: ".github/scripts/custom-validation.sh"
    post_execution:
      - name: "quality_check"
        script: ".github/scripts/quality-check.sh"
```

## サポート

問題や質問がある場合は、以下の方法でサポートを受けられます：

1. **ドキュメント**: このファイルと設定ファイルのコメントを確認
2. **Issue作成**: 問題や改善提案のissueを作成
3. **ディスカッション**: リポジトリのDiscussionsで議論

---

このシステムにより、効率的で安全なAI支援開発環境を構築できます。定期的な設定の見直しとアップデートにより、さらなる改善を図ってください。