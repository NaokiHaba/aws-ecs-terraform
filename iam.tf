# ECSタスク実行ロールのための信頼ポリシーを定義
data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"] # AssumeRole アクションを許可
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"] # ECSタスクサービスからの引き受けを許可
    }
  }
}

# ECSタスク実行ロールを作成
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.app}-ecs-task"                           # アプリケーション名を含むロール名を設定
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json # 上記で定義した信頼ポリシーを適用
}

# ECSタスク実行ポリシーを定義（注意: この定義は重複しているようです）
data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    actions = ["sts:AssumeRole"] # AssumeRole アクションを許可
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"] # ECSタスクサービスからの引き受けを許可
    }
  }
}

# ECS用のIAMロールを作成
resource "aws_iam_role" "ecs" {
  name               = "${local.app}-ecs"                           # アプリケーション名を含むロール名を設定
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json # 注意: ecs_assume ポリシーが未定義です
}

# ECSタスク実行ロールにAmazonECSTaskExecutionRolePolicyをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs.name                                                   # 上記で作成したECSロールにポリシーをアタッチ
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" # AWSマネージドポリシーを使用
}
