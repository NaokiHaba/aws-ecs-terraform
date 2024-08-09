# CloudWatch Logsのロググループを作成
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  # ロググループの名前を設定
  # "/aws/ecs/${local.app}" の形式で、ECSサービス用の標準的な命名規則に従う
  # ${local.app} はアプリケーション名を動的に挿入
  name = "/aws/ecs/${local.app}"

  # ログの保持期間を1日に設定
  # これにより、古いログは自動的に削除され、ストレージコストを抑制
  # 注意: 運用環境では、コンプライアンスやトラブルシューティングのために
  # より長い保持期間を検討することが推奨される
  retention_in_days = 1

  # タグを追加することで、リソースの管理や課金の追跡が容易になる
  # 例: tags = {
  #   Environment = "Development"
  #   Project     = "${local.app}"
  # }
}
