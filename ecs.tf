# ECSタスク定義の作成
# このリソースはECSタスクの詳細な設定を定義します
resource "aws_ecs_task_definition" "ecs_task_definition" {
  # タスク定義のファミリー名をアプリケーション名に設定
  # これにより、関連するタスク定義を簡単に識別できます
  family = local.app

  # ネットワークモードをawsvpcに設定
  # これはFargateで必要な設定で、タスクに専用のENIを提供します
  network_mode = "awsvpc"

  # タスクのCPUとメモリリソースを指定
  # これらの値はFargateの対応する組み合わせに合わせて設定されています
  cpu    = "256"
  memory = "512"

  # Fargateランチタイプを指定
  # これにより、サーバーレスのコンテナ実行環境を使用することを指定します
  requires_compatibilities = ["FARGATE"]

  # タスク実行ロールとタスクロールのARNを指定
  # これらのロールはタスクの実行とタスク内のアプリケーションに必要な権限を提供します
  execution_role_arn = aws_iam_role.ecs.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  # コンテナ定義をJSON形式で指定
  # これはタスク内で実行されるコンテナの詳細な設定を定義します
  container_definitions = jsonencode([
    {
      # コンテナ名をアプリケーション名に設定
      name = "${local.app}"

      # 使用するDockerイメージを指定
      image = "medpeer/health_check:latest"

      # ポートマッピングの設定
      # コンテナポートとホストポートを指定し、トラフィックのルーティングを設定します
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],

      # CloudWatch Logsの設定
      # これによりECSタスクのログをCloudWatch Logsに送信できます
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          # ログの送信先となるCloudWatch Logsのグループ名を指定
          awslogs-group = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

          # ログを送信するAWSリージョンを指定
          awslogs-region = "${local.region}"

          # ログストリームの名前のプレフィックスを指定
          # これにより、ログの識別と管理が容易になります
          awslogs-stream-prefix = "${local.app}"
        }
      },

      # 環境変数の設定
      # これらの変数はコンテナ内のアプリケーションで使用されます
      environment = [
        {
          name  = "NGINX_PORT"
          value = "8080"
        },
        {
          name  = "HEALTH_CHECK_PATH"
          value = "/health_checks"
        }
      ]
    }
  ])
}

# ECSサービスの作成
# このリソースはECSタスクの実行と管理を行います
resource "aws_ecs_service" "ecs_service" {
  # サービス名をアプリケーション名に設定
  name = local.app

  # Fargateを使用するように指定
  launch_type = "FARGATE"

  # サービスを配置するECSクラスターを指定
  cluster = aws_ecs_cluster.ecs_cluster.arn

  # 使用するタスク定義を指定
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn

  # 実行するタスクの数を指定
  desired_count = 2

  # ネットワーク設定
  # タスクを配置するサブネットとセキュリティグループを指定します
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs.id]
  }

  # ロードバランサーの設定
  # タスクをALBのターゲットグループに関連付けます
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = local.app
    container_port   = 8080
  }

  # 依存関係の指定
  # ALBリスナールールが作成された後にこのサービスを作成することを保証します
  depends_on = [aws_lb_listener_rule.alb_listener_rule]
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.app
}
