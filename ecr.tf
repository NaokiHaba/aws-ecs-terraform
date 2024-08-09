# ECRリポジトリの作成
resource "aws_ecr_repository" "ecr_repository" {
  # リポジトリ名をlocals.tfで定義されたアプリケーション名に設定
  name = local.app

  # イメージタグの変更不可を設定（セキュリティ強化のため）
  image_tag_mutability = "IMMUTABLE"

  # リポジトリの強制削除を許可（テスト環境などで便利）
  force_delete = true

  # イメージスキャン設定
  image_scanning_configuration {
    # プッシュ時に自動でスキャンを実行（脆弱性チェックのため）
    scan_on_push = true
  }
}

# ECRライフサイクルポリシーの設定
resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  # ポリシーを適用するリポジトリを指定
  repository = aws_ecr_repository.ecr_repository.name

  # ライフサイクルポリシーをJSON形式で定義
  policy = jsonencode({
    rules = [
      {
        # ルールの優先順位を設定
        rulePriority = 1
        # ルールの説明
        description = "最新の30イメージを保持"
        # イメージの選択条件
        selection = {
          # すべてのタグステータスに適用
          tagStatus = "any"
          # イメージ数でカウント
          countType = "imageCountMoreThan"
          # 30イメージ以上の場合に適用
          countNumber = 30
        }
        # 適用するアクション
        action = {
          # 期限切れとしてマーク（削除対象に）
          type = "expire"
        }
      }
    ]
  })
}
